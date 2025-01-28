extends PauseMenu

func _on_confirm_exit_confirmed():
    GlobalState.save()
    get_tree().quit()

func _on_confirm_main_menu_confirmed():
    GlobalState.save()
    _load_scene(main_menu_scene)
