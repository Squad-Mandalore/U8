extends CanvasLayer

var attack_hover_scene = preload("res://ui/combat/subscenes/attack_hover.tscn")
var attack_hover: AttackHover = null
var enemy: Enemy

func _ready() -> void:
    SignalDispatcher.add_attack_hover.connect(add_attack_hover)
    SignalDispatcher.remove_attack_hover.connect(remove_attack_hover)
    update_combat_hud()

func set_enemy(enemy: Enemy):
    self.enemy = enemy

func update_combat_hud():
    %PlayerStatusPanel.update_status_panel(SourceOfTruth.stats)
    %EnemyStatusPanel.update_status_panel(enemy.stats)
    %AttackSwapper.attacks = SourceOfTruth.get_all_attacks()
    %FeedbackBox.set_feedback("Pick your poison :)")

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
