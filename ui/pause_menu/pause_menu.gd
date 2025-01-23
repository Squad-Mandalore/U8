extends PauseMenu

func _on_confirm_exit_confirmed():
    GlobalState.save()
    get_tree().quit()
