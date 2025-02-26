extends CanvasLayer

var action_key: String

@onready var inventory_info_panel: Control = %InventoryInfoPanel
var attack_hover_scene = preload("res://ui/combat/subscenes/attack_hover.tscn")
var attack_hover: AttackHover = null

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_inventory_stats)
    SignalDispatcher.add_attack_hover.connect(add_attack_hover)
    SignalDispatcher.remove_attack_hover.connect(remove_attack_hover)
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

func add_attack_hover(position: Vector2, attack: Attack):
    attack_hover = attack_hover_scene.instantiate()
    # attack_hover.z_index = 100
    # attack_hover.size = Vector2(382, 255)
    attack_hover.global_position = position
    attack_hover.update_attack_hover(attack)
    add_child(attack_hover)

func remove_attack_hover():
    if attack_hover:
        attack_hover.queue_free()
        attack_hover = null

