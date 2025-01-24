extends Button

@onready var interaction_key_label: Label = $InteractionKeyMarginBox/InteractionKeyLabel

func is_activated_by_shortcut(action: String) -> bool:
    return Input.is_action_just_pressed(action)

func set_key_icon(action: StringName) -> void:
    var talk_action_key = InputMap.action_get_events(action)[0].as_text()[0]
    interaction_key_label.text = talk_action_key
