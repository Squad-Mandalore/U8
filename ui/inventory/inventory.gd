extends CanvasLayer

var action_key: String

@onready var inventory_info_panel: Control = %InventoryInfoPanel
var attack_hover_scene = preload("res://ui/combat/subscenes/attack_hover.tscn")
var attack_hover: AttackHover = null

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_inventory_stats)
    SignalDispatcher.add_attack_hover.connect(add_attack_hover)
    SignalDispatcher.remove_attack_hover.connect(remove_attack_hover)
    SignalDispatcher.interact_button_toggle.connect(interact_button_toggled)
    %InteractButton.set_key_icon("talk")
    %InteractButton.hide()
    %MapButton.set_key_icon("map")
    %MapButton.hide()

func interact_button_toggled(flag = null):
    %InteractButton.visible = flag if flag != null else !%InteractButton.visible

func update_inventory_stats():
    %InventoryHud.update_debuff_stats()
    SignalDispatcher.update_item_slots.emit()
    (%InventoryStatHud as Control).update_inventory_stat_hud()
    update_inventory_balance(SourceOfTruth.balance)
    if SourceOfTruth.meta_inventory_slots[1]:
        %MapButton.show()

func update_inventory_balance(new_balance: int) -> void:
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func _on_map_button_pressed() -> void:
    if not get_parent().close_map():
        SourceOfTruth.meta_inventory_slots[1].interact(0)
    # var slowpoke_tail = preload("res://items/weapons/slowpoke_tail.tres")
    # SourceOfTruth.add_item(slowpoke_tail)
    # SourceOfTruth.add_meta_item(preload("res://items/meta/map.tres"))

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

