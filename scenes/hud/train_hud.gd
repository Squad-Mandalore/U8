extends CanvasLayer

var talk_action_key: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    talk_action_key = InputMap.action_get_events("talk")[0].as_text()[0]
    (%ButtonHud/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = talk_action_key
    %ButtonHud.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func show_interaction_button() -> void:
    %ButtonHud.show()

func hide_interaction_button() -> void:
    %ButtonHud.hide()

func _on_player_stats_changed(stats: StatsSpecifier, balance: int) -> void:
    (%StatusPanel as Control).update_stats(stats, balance)

func _on_button_hud_pressed() -> void:
    if !%ButtonHud.is_activated_by_shortcut("talk"):
        var action_event = InputEventAction.new()
        action_event.action = "talk"
        action_event.pressed = true
        Input.parse_input_event(action_event)
