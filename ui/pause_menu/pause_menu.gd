extends PauseMenu

func _on_confirm_exit_confirmed():
    GlobalState.save()
    get_tree().quit()

func _on_button_mouse_entered() -> void:
    SignalDispatcher.sound_effect.emit("hover_effect")



func _on_button_pressed() -> void:
    SignalDispatcher.sound_effect.emit("button_clicked")

func _on_confirm_main_menu_confirmed():
    GlobalState.save()
    _load_scene(main_menu_scene)
