extends PanelContainer

var index: int
var item: Item
var ck3_progress_bar_value: int

func _ready() -> void:
    SignalDispatcher.set_ck3_progress_bar_value.connect(set_ck3_progress_bar_value)

func set_ck3_progress_bar_value(value: int):
    ck3_progress_bar_value = value

func set_item(new_item: Item):
    item = new_item
    if is_enabled() && item != null:
        (%ItemFrame as TextureRect).texture = item.texture

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
        if item != null:
            SignalDispatcher.toggle_item_hud.emit(item)

func _on_mouse_exited() -> void:
    if is_enabled():
        add_theme_stylebox_override("panel", load("res://assets/hud/item_slot_enabled.tres"))
        if ck3_progress_bar_value != 60:
            SignalDispatcher.toggle_item_hud.emit(null)

func _get_drag_data(at_position: Vector2) -> Variant:
    var data = {}

    data["index"] = index

    var drag_texture = TextureRect.new()
    drag_texture.expand_mode = 1
    drag_texture.texture = %ItemFrame.texture
    drag_texture.size = Vector2(62, 62)

    set_drag_preview(drag_texture)
    %ItemFrame.texture = null

    return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
    return is_enabled()

func _drop_data(at_position: Vector2, data: Variant) -> void:
    var from: int = data["index"]
    SignalDispatcher.swap_inventory_items.emit(from, index)
    SignalDispatcher.update_item_slots.emit()

func _notification(what: int) -> void:
    if what == NOTIFICATION_DRAG_END and not is_drag_successful():
        SignalDispatcher.update_item_slots.emit()
