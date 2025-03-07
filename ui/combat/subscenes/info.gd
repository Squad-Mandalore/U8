extends Control

func _on_panel_container_mouse_exited() -> void:
    SignalDispatcher.remove_info_hover.emit()

func _on_panel_container_mouse_entered() -> void:
    # 267 = Height of info hover 237px + 20 px triangle + 10 px margin - 51px height of info
    # 177 = width of info hover/2 394/2 (197) - half of attack width 42/2 (21)
    var karl_lauterbach: Vector2 = global_position - Vector2(176, -71)
    SignalDispatcher.add_info_hover.emit(karl_lauterbach)
