extends PanelContainer

var item

func set_item(new_item):
    item = new_item
    if is_enabled():
        (%ItemFrame as TextureRect).texture = load(item)

func is_enabled() -> bool:
    var item_slot: StyleBoxFlat = get_theme_stylebox("panel")
    if "enabled" in item_slot.resource_path:
        return true
    return false

func disable():
    add_theme_stylebox_override("panel", load("res://assets/hud/item_slot_disabled.tres"))

func enable():
    add_theme_stylebox_override("panel", load("res://assets/hud/item_slot_enabled.tres"))

func toggle_frame():
    if is_enabled():
        disable()
    else:
        enable()

func _on_mouse_entered() -> void:
    if is_enabled():
        add_theme_stylebox_override("panel", load("res://assets/hud/item_slot_enabled_hovered.tres"))


func _on_mouse_exited() -> void:
    if is_enabled():
        add_theme_stylebox_override("panel", load("res://assets/hud/item_slot_enabled.tres"))

func _get_drag_data(at_position: Vector2) -> Variant:
    var data = {}

    data["drag_texture"] = self.get_child(0).texture

    var drag_texture = TextureRect.new()
    drag_texture.expand_mode = 1
    drag_texture.texture = self.get_child(0).texture
    drag_texture.size = Vector2(62, 62)

    set_drag_preview(drag_texture)

    return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
    return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
    self.get_child(0).texture = data["drag_texture"]

