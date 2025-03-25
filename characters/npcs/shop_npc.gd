extends Npc
class_name ShopNpc

enum SubState { NONE, SHOP }
var _sub_state = SubState.NONE
@export var shop_inventory: Array[Item]
@onready var current_shop_inventory: Array[Item] = shop_inventory.duplicate()
var shop_hud: Control
var shop_info_panel: Control

func _ready() -> void:
    restock_shops()

func restock_shops():
    for i in range(len(shop_inventory)):
        if shop_inventory[i] is not MetaItem:
            current_shop_inventory[i] = shop_inventory[i]
        elif SourceOfTruth.meta_inventory_slots[SourceOfTruth.get_meta_slot_index(shop_inventory[i])]:
            current_shop_inventory[i] = null

func open_shop(shop_canvas: CanvasLayer):
    _sub_state = SubState.SHOP
    shop_hud = shop_canvas.shop_hud
    shop_info_panel = shop_canvas.info_panel
    shop_hud.reload(true, current_shop_inventory, _name, _sprite.sprite_frames)

func close_shop():
    _sub_state = SubState.NONE

func is_shop_open() -> bool:
    return _sub_state == SubState.SHOP
