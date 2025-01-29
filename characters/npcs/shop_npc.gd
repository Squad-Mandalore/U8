extends Npc
class_name ShopNpc

enum SubState { NONE, SHOP }
var _sub_state = SubState.NONE
@export var shop_inventory: Array[Item]

func open_shop():
    _sub_state = SubState.SHOP
    print("shop opened")

func close_shop():
    var _sub_state = SubState.NONE
    print("close shop")

func is_shop_open() -> bool:
    return _sub_state == SubState.SHOP
