extends Control

var ck3_progress_bar_value: int
var stats: StatsSpecifier = null

func _ready() -> void:
    SignalDispatcher.set_ck3_progress_bar_value.connect(set_ck3_progress_bar_value)
    # load_meta_items()
    # item_slots.append("res://ui/hud/assets/coin.svg")

func set_ck3_progress_bar_value(value: int):
    ck3_progress_bar_value = value

func load_meta_items():
    SourceOfTruth.cur_inventory_size = %BackpackItemSlot.inventory_size

func update_debuff_stats():
    self.stats = SourceOfTruth.stats
    load_stat_level("Bleed", stats.bleed_level)
    load_stat_level("Poison", stats.poison_level)
    load_stat_level("Drug", stats.drug_level)

func load_stat_level(stat_name: String, new_stat_level: int):
    var stat_label = get_node("%" + stat_name + "Label")
    stat_label.add_theme_color_override("font_color", Utils.WHITE)

    for i in range(3):
        var stat_level = get_node("%" + stat_name + "Level" + str(i + 1))
        if i + 1 > new_stat_level:
            stat_level.add_theme_stylebox_override("panel", preload("res://ui/hud/assets/debuff_level_disabled.tres"))
        else:
            stat_label.add_theme_color_override("font_color", Utils.RED)
            stat_level.add_theme_stylebox_override("panel", preload("res://ui/hud/assets/debuff_level_enabled.tres"))

func _on_debuff_info_v_box_mouse_exited() -> void:
    if ck3_progress_bar_value != 60:
        SignalDispatcher.toggle_status_types_hud.emit(null)

func _on_debuff_info_v_box_mouse_entered() -> void:
    SignalDispatcher.toggle_status_types_hud.emit(stats)
