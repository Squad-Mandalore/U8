extends Node

signal toggle_item_hud(new_item: Item)
signal toggle_resistance_hud(stats: StatsSpecifier)
signal toggle_status_types_hud(stats: StatsSpecifier)

signal swap_inventory_items(from: int, to: int)
signal set_ck3_progress_bar_value(value: int)

signal stats_changed(delta_stats: StatsSpecifier, delta_balance: int)
signal reload_ui(stats: StatsSpecifier, balance: int)
signal update_item_slots()
signal reset_stats()
signal sound_effect(name: String)
signal sound_music(name: String)
