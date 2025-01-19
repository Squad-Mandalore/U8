extends Node

signal update_item_hud(new_item: Item)
signal update_item_slots()
signal swap_inventory_items(from: int, to: int)
signal set_ck3_progress_bar_value(value: int)
signal stats_changed(stats: StatsSpecifier, balance: int)
