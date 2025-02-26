extends PauseMenu

func _on_confirm_exit_confirmed():
    Questomania.save()
    GlobalState.save()
    get_tree().quit()

func _on_confirm_main_menu_confirmed():
    Questomania.save()
    GlobalState.save()
    _load_scene(main_menu_scene)
