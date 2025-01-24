extends Node2D

signal body_entered(body: Node2D)



func _on_area_2d_2_body_entered(body: Node2D) -> void:
    body_entered.emit(body)
