extends Control

var is_stuck: bool = false

# 267 = Height of info hover 237px + 20 px triangle + 10 px margin - 51px height of info
# 177 = width of info hover/2 394/2 (198) - half of attack width 42/2 (21)
var frank_walter = Vector2(177, -71)

func _on_panel_container_mouse_exited() -> void:
    if not is_stuck:
        SignalDispatcher.remove_info_hover.emit()

func _on_panel_container_mouse_entered() -> void:
    if not is_stuck:
        var karl_lauterbach: Vector2 = global_position - frank_walter
        SignalDispatcher.add_info_hover.emit(karl_lauterbach)

func _on_panel_container_gui_input(event:InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            is_stuck = !is_stuck
            if is_stuck:
                SignalDispatcher.remove_info_hover.emit()
                var habeck: Vector2 = global_position - frank_walter
                SignalDispatcher.add_info_hover.emit(habeck)
            else:
                SignalDispatcher.remove_info_hover.emit()


