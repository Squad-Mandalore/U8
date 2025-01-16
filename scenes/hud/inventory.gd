extends CanvasLayer

var talk_action_key: String

func _ready() -> void:
    talk_action_key = InputMap.action_get_events("inventory")[0].as_text()[0]
    (%InventoryButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = talk_action_key

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_stats(stats: StatsSpecifier, balance: int):
    ($StatHudMargin/StatHud as Control).update_stats(stats)

func _on_inventory_button_pressed() -> void:
    if !(%InventoryButton as Button).is_activated_by_shortcut("inventory"):
        var action_event = InputEventAction.new()
        action_event.action = "inventory"
        action_event.pressed = true
        Input.parse_input_event(action_event)

