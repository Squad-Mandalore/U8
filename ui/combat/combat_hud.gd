extends CanvasLayer

var attack_hover_scene = preload("res://ui/combat/subscenes/attack_hover.tscn")
var attack_hover: AttackHover = null
var enemy: Enemy
var half_turn_counter: int
var first_start: bool
var can_attack: bool = true
var pause_duration: float = 1
@onready var _feedback_box = %FeedbackBox
@onready var _player_status_panel = %PlayerStatusPanel
@onready var _enemy_status_panel = %EnemyStatusPanel
@onready var _attack_swapper = %AttackSwapper
@onready var _round_descriptor = %RoundDescriptor


func _ready() -> void:
    SignalDispatcher.add_attack_hover.connect(add_attack_hover)
    SignalDispatcher.remove_attack_hover.connect(remove_attack_hover)
    SignalDispatcher.execute_attack.connect(execute_attack)
    SignalDispatcher.player_zero_health.connect(exit_combat)
    half_turn_counter = 0
    first_start = calculate_first_start()
    if first_start:
        _feedback_box.set_feedback("Deine Initiative ist höher, als die des Gegners.\nDu darfst starten.")
    else:
        _feedback_box.set_feedback("Der Gegner hat eine höhere Initiative als du.\nEr darf starten.")
    _player_status_panel.stats = SourceOfTruth.stats
    _enemy_status_panel.stats = enemy.stats
    _attack_swapper.attacks = SourceOfTruth.get_all_attacks()
    _round_descriptor.counter = 1

func loop():
    half_turn_counter += 1
    if half_turn_counter % 2 == 0:
        _round_descriptor.increment()

func set_enemy(new_enemy: Enemy):
    self.enemy = new_enemy

func add_attack_hover(position: Vector2, attack: Attack):
    attack_hover = attack_hover_scene.instantiate()
    # attack_hover.z_index = 100
    # attack_hover.size = Vector2(382, 255)
    attack_hover.global_position = position
    attack_hover.update_attack_hover(attack)
    add_child(attack_hover)

func remove_attack_hover():
    if attack_hover:
        attack_hover.queue_free()
        attack_hover = null

# true is player | false is enemy
func calculate_first_start() -> bool:
    var enemy_init = enemy.stats.initiative + (randi() % 3 + 1)
    var player_init = SourceOfTruth.stats.initiative + (randi() % 3 + 1)
    return player_init > enemy_init

func attack_damage(damage: int, defender_stats: StatsSpecifier, damage_receiver: String, damage_donor: String, attacker_token: Utils.AttackTypes, defender_token: Utils.AttackTypes):
    # to calculate netto dmg (actuall recevied dmg)
    # damage is brutto dmg (so unreduced dmg the attacker would deal to defender)
    var received_damage = SourceOfTruth.calculate_damage(damage, defender_stats, attacker_token, defender_token)
    _feedback_box.set_feedback(str(damage_receiver) + " hat " + str(received_damage) + " Schaden durch " + str(damage_donor) + " bekommen!")

    apply_damage(damage_receiver, received_damage, defender_stats)

func effect_damage():
    # additional things for possible future
    # eg arena effects that deal x dmg each turn
    return

func status_type_damage(damage_receiver: String, damage_receiver_stats: StatsSpecifier):
    var received_damage = calc_status_type_dmg(damage_receiver_stats)
    _feedback_box.set_feedback(str(damage_receiver) + " hat " + str(received_damage) + " Schaden durch Status Effekte bekommen!")

    apply_damage(damage_receiver, received_damage, damage_receiver_stats)

    if damage_receiver == enemy._name:
        await pause_action()
        await pause_action()
        _feedback_box.set_feedback(" Bitte wähle deinen nächsten Angriff!")

func apply_damage(damage_receiver: String, received_damage: int, damage_receiver_stats: StatsSpecifier):
    # TODO: use stats_changed when player stats are used
    if damage_receiver == "Spieler":
        var delta_stats = StatsSpecifier.new()
        delta_stats.health = -received_damage
        SourceOfTruth.stats_changed(delta_stats)
    else:
        damage_receiver_stats.health -= received_damage
        if damage_receiver_stats.health <= 0:
            exit_combat()

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

func execute_attack(attack: Attack, active_combatant: String, passive_combatant: String):
    if passive_combatant == "Enemy":
        passive_combatant = enemy._name

    if not can_attack && active_combatant == "Spieler":
        return
    loop()

    var damage_donor_panel
    var damage_receiver_panel
    var damage_receiver_stats
    var damage_donnor_stats
    if active_combatant == "Spieler":
        damage_donor_panel = _player_status_panel
        damage_receiver_panel = _enemy_status_panel
        damage_receiver_stats = enemy.stats
        damage_donnor_stats = SourceOfTruth.stats
    else:
        damage_donor_panel = _enemy_status_panel
        damage_receiver_panel = _player_status_panel
        damage_receiver_stats = SourceOfTruth.stats
        damage_donnor_stats = enemy.stats

    for token_number in attack.token_number:
        damage_donor_panel.add_token(attack.token)

    var damage_donor = active_combatant
    var damage_receiver = passive_combatant
    attack_damage(attack.damage, damage_receiver_stats, damage_receiver, damage_donor, attack.token, damage_receiver_panel.stance)
    damage_donor_panel.update_status_panel()
    damage_receiver_panel.update_status_panel()
    await pause_action()

    effect_damage()
    damage_donor_panel.update_status_panel()
    damage_receiver_panel.update_status_panel()
    await pause_action()

    status_type_damage(damage_donor, damage_donnor_stats)
    damage_donor_panel.update_status_panel()
    damage_receiver_panel.update_status_panel()
    await pause_action()

    if damage_donor == "Spieler":
        await pause_action()
        enemy_execute_attack()

func pause_action():
    can_attack = false
    await get_tree().create_timer(pause_duration).timeout
    can_attack = true

func enemy_execute_attack():
    var chosen_attack_index: int = randi() % len(enemy.attacks)
    var chosen_attack = enemy.attacks[chosen_attack_index]
    # TODO: play attack animation and hide hud
    execute_attack(chosen_attack, enemy._name, "Spieler")

func exit_combat():
    # TODO: winning screen here and on click combat exit
    SignalDispatcher.combat_exit.emit(get_parent())
