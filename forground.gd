extends Area2D


func _on_body_entered(body:Node2D) -> void:
    if is_instance_of(body, Player):
        hide()
