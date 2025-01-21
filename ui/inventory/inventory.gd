extends CanvasLayer

var action_key: String
@onready var inventory_sound_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
    SignalDispatcher.stats_changed.connect(update_inventory_stats)
    action_key = InputMap.action_get_events("inventory")[0].as_text()[0]
    (%InventoryButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = action_key
    action_key = InputMap.action_get_events("map")[0].as_text()[0]
    (%MapButton/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = action_key

func update_inventory_stats(stats: StatsSpecifier, balance: int):
    %InventoryHud.update_debuff_stats(stats)
    (%InventoryStatHud as Control).update_inventory_stat_hud(stats)
    update_inventory_balance(balance)

func update_inventory_balance(new_balance: int) -> void:
    var min_balance: int
    new_balance = max(min_balance, new_balance)
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func _on_inventory_button_pressed() -> void:
    (get_parent() as Player).toggle_inventory()

func _on_map_button_pressed() -> void:
    var regenmantel = load("res://items/armor/regenmantel.tres")
    SignalDispatcher.item_added.emit(regenmantel)
