extends PauseMenu

func _on_confirm_exit_confirmed():
    Questomania.save()
    GlobalState.save()
    get_tree().quit()
