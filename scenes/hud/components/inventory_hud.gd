extends Control

var cur_inventory_size: int = 4
var max_inventory_size: int = 16
var item_slots: Array[Item]
var ck3_progress_bar_value: int
var stats: StatsSpecifier = null

func _ready() -> void:
    SignalDispatcher.set_ck3_progress_bar_value.connect(set_ck3_progress_bar_value)
    SignalDispatcher.update_item_slots.connect(load_item_slots)
    SignalDispatcher.swap_inventory_items.connect(swap_item)
    # load_meta_items()
    # item_slots.append("res://assets/hud/coin.svg")
    # load_item_slots()
    item_slots.resize(max_inventory_size)
    item_slots.fill(null)

func set_ck3_progress_bar_value(value: int):
    ck3_progress_bar_value = value

func load_item_slots():
    for i in range(max_inventory_size):
        var item_slot = get_node("%ItemSlot" + str(i + 1))
        item_slot.index = i
        if i + 1 > cur_inventory_size:
            item_slot.disable()
        else:
            item_slot.enable()
            item_slot.set_item(item_slots[i])

func load_meta_items():
    cur_inventory_size = %BackpackItemSlot.inventory_size

func update_debuff_stats(stats: StatsSpecifier):
    self.stats = stats
    load_stat_level("Bleed", stats.bleed_level)
    load_stat_level("Poison", stats.poison_level)
    load_stat_level("Drug", stats.drug_level)

func load_stat_level(stat_name: String, new_stat_level: int):
    const white: Color = Color("FFFFFF")
    const red: Color = Color("FF4346")
    var stat_label = get_node("%" + stat_name + "Label")
    stat_label.add_theme_color_override("font_color", white)

    for i in range(3):
        var stat_level = get_node("%" + stat_name + "Level" + str(i + 1))
        if i + 1 > new_stat_level:
            stat_level.add_theme_stylebox_override("panel", load("res://assets/hud/debuff_level_disabled.tres"))
        else:
            stat_label.add_theme_color_override("font_color", red)
            stat_level.add_theme_stylebox_override("panel", load("res://assets/hud/debuff_level_enabled.tres"))

func add_item(item: Item):
    # TODO: else case
    for i in range(len(item_slots)):
        if item_slots[i] == null:
            item_slots[i] = item
            load_item_slots()
            return

func remove_item(i: int):
    if i < len(item_slots):
        item_slots[i] = null
        load_item_slots()
        return

func swap_item(from: int, to: int):
    var tmp = item_slots[from]
    item_slots[from] = item_slots[to]
    item_slots[to] = tmp

func _on_debuff_info_v_box_mouse_exited() -> void:
    if ck3_progress_bar_value != 60:
        SignalDispatcher.toggle_status_types_hud.emit(null)

func _on_debuff_info_v_box_mouse_entered() -> void:
    SignalDispatcher.toggle_status_types_hud.emit(stats)

