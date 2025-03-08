extends CanvasLayer

const ATTACK_HOVER_SCENE = preload("res://ui/combat/subscenes/attack_hover.tscn")
const INFO_HOVER_SCENE = preload("res://ui/combat/subscenes/info_hover.tscn")
var attack_hover: AttackHover = null
var info_hover: Control = null
var enemy: Enemy
var half_turn_counter: int
var first_start: bool
var is_fight_over: bool = false
var pause_duration: float = 1
@onready var _feedback_box = %FeedbackBox
@onready var _player_status_panel = %PlayerStatusPanel
@onready var _enemy_status_panel = %EnemyStatusPanel
@onready var _attack_swapper = %AttackSwapper
@onready var _round_descriptor = %RoundDescriptor

# initializes the combat loop
func _ready() -> void:
    SignalDispatcher.add_attack_hover.connect(add_attack_hover)
    SignalDispatcher.add_info_hover.connect(add_info_hover)
    SignalDispatcher.remove_attack_hover.connect(remove_attack_hover)
    SignalDispatcher.remove_info_hover.connect(remove_info_hover)
    SignalDispatcher.execute_attack.connect(execute_attack)
    SignalDispatcher.player_zero_health.connect(_player_lost)
    SignalDispatcher.attack_swapper_toggle.connect(attack_swapper_toggled)
    half_turn_counter = 0
    first_start = calculate_first_start()
    _player_status_panel.stats = SourceOfTruth.stats
    _enemy_status_panel.stats = enemy.stats
    _attack_swapper.attacks = SourceOfTruth.get_all_attacks()
    _round_descriptor.counter = 1
    if first_start:
        _feedback_box.add_message("Deine Initiative ist höher, als die des Gegners.\nDu darfst starten.")
    else:
        _feedback_box.add_message("Der Gegner hat eine höhere Initiative als du.\nEr darf starten.")
        enemy_execute_attack()
        SignalDispatcher.attack_swapper_toggle.emit(false)

# after initialization this function starts the loop
func execute_attack(attack: Attack, active_combatant: String, passive_combatant: String):
    if is_fight_over:
        return

    loop()

    var damage_donor_panel
    var damage_donor_stats
    var damage_receiver_panel
    var damage_receiver_stats
    if active_combatant == "Spieler":
        damage_donor_panel = _player_status_panel
        damage_donor_stats = SourceOfTruth.stats
        damage_receiver_panel = _enemy_status_panel
        damage_receiver_stats = enemy.stats
        passive_combatant = enemy._name
    else:
        damage_donor_panel = _enemy_status_panel
        damage_donor_stats = enemy.stats
        damage_receiver_panel = _player_status_panel
        damage_receiver_stats = SourceOfTruth.stats

    var previous_stance = damage_donor_panel.stance
    for token_number in attack.token_number:
        damage_donor_panel.add_token(attack.token)

    if previous_stance != damage_donor_panel.stance:
        _feedback_box.add_message(str(active_combatant) + " hat die Kampfhaltung zu " + Utils.AttackTypes.keys()[damage_donor_panel.stance] + " gewechselt")

    _feedback_box.add_message(str(active_combatant) + " setzt " + attack.name + " ein!")
    attack_damage(attack, damage_receiver_stats, passive_combatant, active_combatant, damage_receiver_panel.stance)
    damage_donor_panel.update_status_panel()
    damage_receiver_panel.update_status_panel()
    get_parent().enable_aura(Utils.ATTACK_DICT[Utils.AttackTypes.find_key(damage_donor_panel.stance)].color, active_combatant)

    effect_damage()
    damage_donor_panel.update_status_panel()
    damage_receiver_panel.update_status_panel()

    status_type_damage(active_combatant, damage_donor_stats)
    damage_donor_panel.update_status_panel()
    damage_receiver_panel.update_status_panel()

    if active_combatant == "Spieler":
        enemy_execute_attack()

func enemy_execute_attack():
    var chosen_attack_index: int = randi() % len(enemy.attacks)
    var chosen_attack = enemy.attacks[chosen_attack_index]
    # TODO: play attack animation and hide hud
    execute_attack(chosen_attack, enemy._name, "Spieler")

func loop():
    half_turn_counter += 1
    if half_turn_counter % 2 == 0:
        _round_descriptor.increment()

func set_enemy(new_enemy: Enemy):
    self.enemy = new_enemy

func add_attack_hover(position: Vector2, attack: Attack):
    attack_hover = ATTACK_HOVER_SCENE.instantiate()
    attack_hover.global_position = position
    attack_hover.update_attack_hover(attack)
    add_child(attack_hover)

func add_info_hover(position: Vector2):
    info_hover = INFO_HOVER_SCENE.instantiate()
    info_hover.global_position = position
    add_child(info_hover)

func remove_attack_hover():
    if attack_hover:
        attack_hover.queue_free()
        attack_hover = null

func remove_info_hover():
    if info_hover:
        info_hover.queue_free()
        info_hover = null

# true is player | false is enemy
func calculate_first_start() -> bool:
    var enemy_init = enemy.stats.initiative + (randi() % 3 + 1)
    var player_init = SourceOfTruth.stats.initiative + (randi() % 3 + 1)
    return player_init > enemy_init

func attack_damage(attack: Attack, defender_stats: StatsSpecifier, damage_receiver: String, damage_donor: String, defender_token: Utils.AttackTypes):
    # to calculate netto dmg (actuall recevied dmg)
    # damage is brutto dmg (so unreduced dmg the attacker would deal to defender)
    var attacker_token = attack.token
    var result = SourceOfTruth.calculate_damage(attack.damage, defender_stats, attacker_token, defender_token)
    var received_damage = -result["damage"].health
    _feedback_box.add_message(str(damage_receiver) + " hat " + str(received_damage) + " Schaden durch " + str(damage_donor) + " bekommen!")
    match result["reason"]:
        "dodged":
            _feedback_box.add_message(str(damage_receiver) + "ist dem Angriff " + attack.name + " ausgewichen!")
        "effective":
            _feedback_box.add_message(attack.name + " war durch Kampfhaltung " + Utils.AttackTypes.keys()[defender_token] + " sehr effektiv!")
        "weak":
            _feedback_box.add_message(attack.name + " war durch Kampfhaltung " + Utils.AttackTypes.keys()[defender_token] + " nicht effektiv!")

    apply_damage(damage_receiver, result["damage"], defender_stats)

func effect_damage():
    # additional things for possible future
    # eg arena effects that deal x dmg each turn
    return

func status_type_damage(damage_receiver: String, damage_receiver_stats: StatsSpecifier):
    var received_damage = StatsSpecifier.new()
    received_damage.health = -calc_status_type_dmg(damage_receiver_stats)

    if received_damage.health != 0:
       _feedback_box.add_message(str(damage_receiver) + " hat " + str(-received_damage.health) + " Schaden durch Status Effekte bekommen!")

    apply_damage(damage_receiver, received_damage, damage_receiver_stats)

    if damage_receiver == enemy._name:
        _feedback_box.add_message("Bitte wähle deinen nächsten Angriff!")

func apply_damage(damage_receiver: String, received_damage: StatsSpecifier, damage_receiver_stats: StatsSpecifier):
    # TODO: use stats_changed when player stats are used
    if damage_receiver == "Spieler":
        # var delta_stats = StatsSpecifier.new()
        # delta_stats.health = -received_damage
        SourceOfTruth.stats_changed(received_damage)
    else:
        # damage_receiver_stats.health -= received_damage
        damage_receiver_stats.add(received_damage)
        if damage_receiver_stats.health <= 0:
            enemy.fight_lost()
            _player_won()

func calc_status_type_dmg(defender_stats: StatsSpecifier) -> int:
    # apply dmg from status_types
    # bleed
    match defender_stats.bleed_level:
        0: pass
        1: return int(5 * ((100 - defender_stats.bleed_resistance)/100.0))
        2: return int(10 * ((100 - defender_stats.bleed_resistance)/100.0))
        3: return int(20 * ((100 - defender_stats.bleed_resistance)/100.0))
        _: pass

    # poison
    match defender_stats.poison_level:
        0: pass
        1: return int(5 * ((100 - defender_stats.poison_resistance)/100.0))
        2: return int(10 * ((100 - defender_stats.poison_resistance)/100.0))
        3: return int(20 * ((100 - defender_stats.poison_resistance)/100.0))
        _: pass

    # drug
    match defender_stats.drug_level:
        0: pass
        1: return int(5 * ((100 - defender_stats.drug_resistance)/100.0))
        2: return int(10 * ((100 - defender_stats.drug_resistance)/100.0))
        3: return int(20 * ((100 - defender_stats.drug_resistance)/100.0))
        _: pass
    return 0

# func pause_action():
#     can_attack = false
#     await Utils.create_timer(pause_duration)
#     can_attack = true

func _player_lost():
    is_fight_over = true
    SignalDispatcher.player_lost_combat.emit(get_parent())

func _player_won():
    is_fight_over = true
    SignalDispatcher.player_won_combat.emit(get_parent())

func attack_swapper_toggled(flag = null):
    _attack_swapper.visible = flag if flag != null else !_attack_swapper.visible
