extends CanvasLayer

var talk_action_key: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    talk_action_key = InputMap.action_get_events("talk")[0].as_text()[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func show_interaction_button(discription: String) -> void:
    $MarginContainer/HBoxContainer/Interaction.text = talk_action_key + " - " + discription
    $MarginContainer/HBoxContainer/Interaction.show()

func hide_interaction_button() -> void:
    $MarginContainer/HBoxContainer/Interaction.hide()
