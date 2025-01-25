extends CanvasLayer

var attack_hover_scene = preload("res://ui/combat/subscenes/attack_hover.tscn")
var attack_hover: AttackHover = null
var enemy: Enemy

func _ready() -> void:
    SignalDispatcher.add_attack_hover.connect(add_attack_hover)
    SignalDispatcher.remove_attack_hover.connect(remove_attack_hover)
    SignalDispatcher.execute_attack.connect(execute_attack)
    update_combat_hud()

func set_enemy(enemy: Enemy):
    self.enemy = enemy

func update_combat_hud():
    if calculate_first_start():
        %FeedbackBox.set_feedback("Deine Initiative ist höher, als die des Gegners.\nDu darfst starten.")
    %PlayerStatusPanel.stats = SourceOfTruth.stats
    %EnemyStatusPanel.stats = enemy.stats
    %AttackSwapper.attacks = SourceOfTruth.get_all_attacks()
    %RoundDescriptor.counter = 1

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

func take_damage(damage: int, stats: StatsSpecifier):
    var received_damage = SourceOfTruth.calculate_damage(damage, stats)
    stats.health -= received_damage
    if stats.health <= 0:
        # TODO: winning screen here and on click combat exit
        SignalDispatcher.combat_exit.emit(get_parent())

func execute_attack(attack: Attack, attacker: String):
    var attacker_panel = get_node("%" + attacker + "StatusPanel")
    var defender_panel
    var enemy_stats
    if attacker == "Player":
        defender_panel = get_node("%" + "Enemy" + "StatusPanel")
        enemy_stats = enemy.stats
    else:
        %RoundDescriptor.increment()
        defender_panel = get_node("%" + "Player" + "StatusPanel")
        enemy_stats = SourceOfTruth.stats
    for token_number in attack.token_number:
        attacker_panel.add_token(attack.token)
    take_damage(attack.damage, enemy_stats)
    attacker_panel.update_status_panel()
    defender_panel.update_status_panel()
    %FeedbackBox.set_feedback(attacker + " hat " + str(attack.damage) + " Schaden gemacht.")
    # TODO: needs better logic here
    await get_tree().create_timer(2).timeout
    if attacker == "Player":
        enemy_execute_attack()

func enemy_execute_attack():
    var chosen_attack_index: int = randi() % len(enemy.attacks)
    var chosen_attack = enemy.attacks[chosen_attack_index]
    # TODO: play attack animation and hide hud
    execute_attack(chosen_attack, "Enemy")

