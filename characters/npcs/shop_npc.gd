extends Npc
class_name ShopNpc

enum SubState { NONE, SHOP }
var _sub_state = SubState.NONE
@export var shop_inventory: Array[Item]
@export var shop_name: String
var shop_hud: Control
var shop_info_panel: Control

func open_shop(shop_canvas: CanvasLayer):
    _sub_state = SubState.SHOP
    shop_hud = shop_canvas.shop_hud
    shop_info_panel = shop_canvas.info_panel
    shop_hud.reload(true, shop_inventory, _sprite.sprite_frames)

func close_shop():
    var _sub_state = SubState.NONE
    print("close shop")

func is_shop_open() -> bool:
    return _sub_state == SubState.SHOP
