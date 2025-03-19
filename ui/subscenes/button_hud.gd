extends Button

@onready var interaction_key_label: Label = $InteractionKeyMarginBox/InteractionKeyLabel
@export var action_event_key: String = "talk"

func _ready() -> void:
    set_key_icon(action_event_key)

func set_key_icon(action: StringName) -> void:
    var talk_action_key = InputMap.action_get_events(action)[0].as_text()[0]
    interaction_key_label.text = talk_action_key
