extends StaticBody2D
class_name Automata

@export var shop_inventory: Array[Item]
@export var shop_name: String
var shop_hud: Control
var shop_info_panel: Control

func open_shop(shop_canvas: CanvasLayer):
    shop_hud = shop_canvas.shop_hud
    shop_info_panel = shop_canvas.info_panel
    shop_hud.reload(false, shop_inventory, shop_name)

func close_shop():
    pass

func enable_outline(color : Color = Color(0, 1, 0, 1)) -> void:
    pass

func disable_outline() -> void:
    pass
