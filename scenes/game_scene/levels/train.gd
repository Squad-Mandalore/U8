extends Node2D

signal level_won


func _on_area_2d_body_entered(_body: Node2D) -> void:
    level_won.emit()

