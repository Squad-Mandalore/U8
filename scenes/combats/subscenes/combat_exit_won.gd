extends CanvasLayer

@onready var enemy_label = $ColorRect/Panel/Enemy_Label
var enemy: Enemy

func _ready() -> void:
    update_enemy(enemy)

func update_enemy(enemy: Enemy) -> void:
    enemy_label.text = enemy._name
