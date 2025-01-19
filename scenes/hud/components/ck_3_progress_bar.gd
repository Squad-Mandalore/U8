extends TextureProgressBar

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            SignalDispatcher.update_item_hud.emit(null)
