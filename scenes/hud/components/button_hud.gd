extends Button

func is_activated_by_shortcut(action: String) -> bool:
    if Input.is_action_just_pressed(action):
        return true
    return false
