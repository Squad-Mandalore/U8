extends PauseMenu

func _on_ready():
	SignalDispatcher.sound_effect.emit("pop")

func _on_confirm_exit_confirmed():
	Questomania.save()
	GlobalState.save()
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	SignalDispatcher.sound_effect.emit("hover_effect")

func _on_back_to_main_menu_pressed() -> void:
	SignalDispatcher.sound_music.emit("main_menu")

func _on_button_pressed() -> void:
	SignalDispatcher.sound_effect.emit("button_clicked")

func _on_confirm_main_menu_confirmed():
	Questomania.save()
	GlobalState.save()
	_load_scene(main_menu_scene)

func _on_menu_entered():
	SignalDispatcher.sound_effect.emit("pop")

func _on_menu_exited():
	SignalDispatcher.sound_effect.emit("exit")
