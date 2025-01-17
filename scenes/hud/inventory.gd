extends CanvasLayer

var action_key: String

func _ready() -> void:
    action_key = InputMap.action_get_events("inventory")[0].as_text()[0]
    (%InventoryButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = action_key
    action_key = InputMap.action_get_events("map")[0].as_text()[0]
    (%MapButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = action_key

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_stats(stats: StatsSpecifier, balance: int):
    %InventoryHud.load_stats(stats)
    (%StatHud as Control).update_stats(stats)
    update_balance(balance)

func update_balance(new_balance: int) -> void:
    var min_balance: int
    new_balance = max(min_balance, new_balance)
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func _on_inventory_button_pressed() -> void:
    const local_action_event: String = "inventory"
    if !(%InventoryButton as Button).is_activated_by_shortcut(local_action_event):
        var action_event = InputEventAction.new()
        action_event.action = local_action_event
        action_event.pressed = true
        Input.parse_input_event(action_event)

func _on_map_button_pressed() -> void:
    const local_action_event: String = "map"
    if !(%MapButton as Button).is_activated_by_shortcut(local_action_event):
        var action_event = InputEventAction.new()
        action_event.action = local_action_event
        action_event.pressed = true
        Input.parse_input_event(action_event)
