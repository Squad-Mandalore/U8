extends CanvasLayer

var action_key: String

@onready var inventory_info_panel: Control = %InventoryInfoPanel

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_inventory_stats)
    %InventoryButton.set_key_icon("inventory")
    %MapButton.set_key_icon("map")

func update_inventory_stats():
    %InventoryHud.update_debuff_stats()
    SignalDispatcher.update_item_slots.emit()
    (%InventoryStatHud as Control).update_inventory_stat_hud()
    update_inventory_balance(SourceOfTruth.balance)

func update_inventory_balance(new_balance: int) -> void:
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func _on_inventory_button_pressed() -> void:
    # (get_parent() as Player).toggle_inventory()
    SourceOfTruth.remove_item(3)
    # TODO: remove this once drugs are implemented!!!!!!! DEBUG DEBUG
    var new_stats = StatsSpecifier.new()
    new_stats.drug_level = new_stats.drug_level + 1
    SourceOfTruth.stats_changed(new_stats)

func _on_map_button_pressed() -> void:
    var slowpoke_tail = preload("res://items/weapons/slowpoke_tail.tres")
    SourceOfTruth.add_item(slowpoke_tail)
