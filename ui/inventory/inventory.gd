extends CanvasLayer

var action_key: String

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_inventory_stats)
    action_key = InputMap.action_get_events("inventory")[0].as_text()[0]
    (%InventoryButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = action_key
    action_key = InputMap.action_get_events("map")[0].as_text()[0]
    (%MapButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = action_key

func update_inventory_stats():
    %InventoryHud.update_debuff_stats()
    %InventoryHud.load_item_slots()
    (%InventoryStatHud as Control).update_inventory_stat_hud()
    update_inventory_balance()

func update_inventory_balance() -> void:
    var min_balance: int
    var new_balance = max(min_balance, SourceOfTruth.balance)
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func _on_inventory_button_pressed() -> void:
    # (get_parent() as Player).toggle_inventory()
    SourceOfTruth.remove_item(3)

func _on_map_button_pressed() -> void:
    var slowpoke_tail = preload("res://items/weapons/slowpoke_tail.tres")
    SourceOfTruth.add_item(slowpoke_tail)
