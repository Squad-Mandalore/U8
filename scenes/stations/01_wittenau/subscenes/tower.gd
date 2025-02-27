extends StaticBody2D
class_name Tower


func _on_area_2d_body_exited(_body: Node2D) -> void:
    modulate.a = 1

func _on_area_2d_body_entered(_body: Node2D) -> void:
    modulate.a = 0.5
