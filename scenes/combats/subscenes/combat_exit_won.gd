extends CanvasLayer

@onready var enemy_label = $ColorRect/Panel/Enemy_Label

func _ready() -> void:
    pass

func update_enemy(enemy: Enemy) -> void:
    enemy_label.text = enemy._name
