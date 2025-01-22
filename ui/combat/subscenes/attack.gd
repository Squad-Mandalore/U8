extends Control

func _on_panel_container_mouse_exited() -> void:
    $PanelContainer.add_theme_stylebox_override("panel", load("res://ui/combat/assets/attack.tres"))
    SignalDispatcher.remove_attack_hover.emit()

func _on_panel_container_mouse_entered() -> void:
    $PanelContainer.add_theme_stylebox_override("panel", load("res://ui/combat/assets/attack_on_hover.tres"))
    # 285 = Height of attack hover 255px + 20 px triangle + 10 px margin
    # 113 = width of attack hover/2 382/2 (191) - half of attack width 156/2 (78)
    SignalDispatcher.add_attack_hover.emit(global_position - Vector2(113, 285))
