extends Node2D

signal train_enter

func _on_area_2d_body_enterd(_body: Node2D) -> void:
    train_enter.emit()
