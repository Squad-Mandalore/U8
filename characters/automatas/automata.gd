extends StaticBody2D
class_name Automata

@export var shop_inventory: Array[Item]
@onready var current_shop_inventory: Array[Item] = shop_inventory.duplicate()
@export var shop_name: String
@onready var sprite2D = $Sprite2D
const outline_shader = preload("res://characters/npcs/assets/npc.gdshader")
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
    shop_hud = shop_canvas.shop_hud
    shop_info_panel = shop_canvas.info_panel
    shop_hud.reload(false, current_shop_inventory, shop_name, sprite2D.texture)

func close_shop():
    pass

func enable_outline(color : Color = Color(0, 1, 0, 1)) -> void:
    # Create and assign a ShaderMaterial with the given outline shader
    if outline_shader:
        var mat = ShaderMaterial.new()
        mat.shader = outline_shader
        # Adjust parameters as needed
        mat.set_shader_parameter("outline_thickness", 0.5)
        mat.set_shader_parameter("outline_color", color)
        sprite2D.material = mat
    else:
        # No shader assigned
        sprite2D.material = null

func disable_outline() -> void:
    sprite2D.material = null

# Constants for distances (tweak as needed)
const CHECK_DISTANCE: float = 24.0
const MOVE_OFFSET: float = 5.0
