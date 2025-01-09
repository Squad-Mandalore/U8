extends Node2D

signal train_enter


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        train_enter.emit()

