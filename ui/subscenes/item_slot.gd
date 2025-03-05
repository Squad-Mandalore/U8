extends PanelContainer

var index: int
var item: Item:
    set(value):
        item = value
        if value is MetaItem:
            enable()
var ck3_progress_bar_value: int
var is_shop_slot: bool = false

func _ready() -> void:
    SignalDispatcher.set_ck3_progress_bar_value.connect(set_ck3_progress_bar_value)

func set_ck3_progress_bar_value(value: int):
    ck3_progress_bar_value = value

func set_item(new_item: Item):
    item = new_item
    if is_enabled():
        if item != null:
            (%ItemFrame as TextureRect).texture = item.texture
        else:
            (%ItemFrame as TextureRect).texture = null

func is_enabled() -> bool:
    var item_slot: StyleBoxFlat = get_theme_stylebox("panel")
    if "enabled" in item_slot.resource_path:
        return true
    return false

func disable():
    item = null
    (%ItemFrame as TextureRect).texture = null
    add_theme_stylebox_override("panel", preload("res://ui/assets/item_slot_disabled.tres"))

func enable():
    add_theme_stylebox_override("panel", preload("res://ui/assets/item_slot_enabled.tres"))

func toggle_frame():
    if is_enabled():
        disable()
    else:
        enable()

func is_hovered():
    var item_slot: StyleBoxFlat = get_theme_stylebox("panel")
    if "hovered" in item_slot.resource_path:
        return true
    return false

func _unhandled_input(event: InputEvent):
    if event.is_action_pressed("talk") && is_hovered() && item && item.has_method("interact"):
        item.interact(index)

func _on_mouse_entered() -> void:
    if is_enabled():
        add_theme_stylebox_override("panel", preload("res://ui/assets/item_slot_enabled_hovered.tres"))
        SignalDispatcher.sound_effect.emit("hover_effect")
        if item:
            if item.has_method("interact"):
                print(item)
                print("hello")
                SignalDispatcher.interact_button_toggle.emit(true)
            SignalDispatcher.toggle_item_hud.emit(item, is_shop_slot)
            if is_shop_slot:
                SignalDispatcher.update_shop_dialogue_box.emit(item)

func _on_mouse_exited() -> void:
    SignalDispatcher.interact_button_toggle.emit(false)
    if is_enabled():
        add_theme_stylebox_override("panel", preload("res://ui/assets/item_slot_enabled.tres"))
        if ck3_progress_bar_value != 60:
            SignalDispatcher.toggle_item_hud.emit(null)

func _get_drag_data(at_position: Vector2) -> Variant:
    if !is_enabled() || (item is MetaItem && !is_shop_slot):
        return
    var data = {}

    data["index"] = index
    data["is_shop_slot"] = is_shop_slot
    data["item"] = item

    var drag_texture = TextureRect.new()
    drag_texture.expand_mode = 1
    drag_texture.texture = %ItemFrame.texture
    drag_texture.size = Vector2(62, 62)

    set_drag_preview(drag_texture)
    %ItemFrame.texture = null

    return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
    return is_enabled() and !is_shop_slot and !item is MetaItem

func _drop_data(at_position: Vector2, data: Variant) -> void:
    var from: int = data["index"]
    var ext_is_shop_slot: bool = data["is_shop_slot"]
    var ext_item: Item = data["item"]
    if ext_is_shop_slot:
        # attempt to buy
        if  SourceOfTruth.balance >= ext_item.price:
            if ext_item is MetaItem:
                SourceOfTruth.add_meta_item(ext_item)
            else:
                SourceOfTruth.add_item(ext_item)
            SourceOfTruth.balance_changed(-ext_item.price)
            SignalDispatcher.update_item_slots.emit()
            SignalDispatcher.update_shop_item_slots.emit(from)
            # enough money
        else:
            # not enough money
            SignalDispatcher.update_shop_item_slots.emit()
    else:
        SourceOfTruth.swap_item(from, index)
        SignalDispatcher.update_item_slots.emit()

func _notification(what: int) -> void:
    # WARNING this will send to all item slots even those who are not affected VERY PERFORMANCE HEAVY
    if what == NOTIFICATION_DRAG_END and not is_drag_successful():
        if is_shop_slot:
            SignalDispatcher.update_shop_item_slots.emit()
        SignalDispatcher.update_item_slots.emit()
