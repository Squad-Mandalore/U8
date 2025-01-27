extends CanvasLayer

var attack_hover_scene = preload("res://ui/combat/subscenes/attack_hover.tscn")
var attack_hover: AttackHover = null
var enemy: Enemy
var half_turn_counter: int
var first_start: bool
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

func set_enemy(enemy: Enemy):
    self.enemy = enemy

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

func take_damage(damage: int, stats: StatsSpecifier, attacker: String):
    var received_damage = SourceOfTruth.calculate_damage(damage, stats)
    # TODO: use stats_changed when player stats are used
    if attacker == "Enemy":
        var delta_stats = StatsSpecifier.new()
        delta_stats.health = -received_damage
        SourceOfTruth.stats_changed(delta_stats)
    else:
        stats.health -= received_damage
        if stats.health <= 0:
            # TODO: winning screen here and on click combat exit
            exit_combat()

func execute_attack(attack: Attack, attacker: String):
    loop()

    var attacker_panel
    var defender_panel
    var enemy_stats
    if attacker == "Player":
        attacker_panel = _player_status_panel
        defender_panel = _enemy_status_panel
        enemy_stats = enemy.stats
    else:
        attacker_panel = _enemy_status_panel
        defender_panel = _player_status_panel
        enemy_stats = SourceOfTruth.stats

    for token_number in attack.token_number:
        attacker_panel.add_token(attack.token)
    take_damage(attack.damage, enemy_stats, attacker)
    attacker_panel.update_status_panel()
    defender_panel.update_status_panel()
    _feedback_box.set_feedback(attacker + " hat " + str(attack.damage) + " Schaden gemacht.")
    # TODO: needs better logic here
    await get_tree().create_timer(2).timeout
    if attacker == "Player":
        enemy_execute_attack()

func enemy_execute_attack():
    var chosen_attack_index: int = randi() % len(enemy.attacks)
    var chosen_attack = enemy.attacks[chosen_attack_index]
    # TODO: play attack animation and hide hud
    execute_attack(chosen_attack, "Enemy")

func exit_combat():
    SignalDispatcher.combat_exit.emit(get_parent())
