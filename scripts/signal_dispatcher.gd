extends Node

signal toggle_item_hud(new_item: Item)
signal toggle_resistance_hud(stats: StatsSpecifier)
signal toggle_status_types_hud(stats: StatsSpecifier)
signal update_item_slots()
signal swap_inventory_items(from: int, to: int)
signal set_ck3_progress_bar_value(value: int)
signal stats_changed(stats: StatsSpecifier, balance: int)
signal item_added(item: Item)
signal reset_stats()
