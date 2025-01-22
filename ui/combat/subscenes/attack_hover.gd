extends Control
class_name AttackHover

func _ready() -> void:
    $Polygon2D.global_position = global_position + Vector2(171, 253)
