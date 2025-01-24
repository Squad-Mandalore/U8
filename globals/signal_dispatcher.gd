extends Node

signal toggle_item_hud(new_item: Item)
signal toggle_resistance_hud(stats: StatsSpecifier)
signal toggle_status_types_hud(stats: StatsSpecifier)

signal swap_inventory_items(from: int, to: int)
signal set_ck3_progress_bar_value(value: int)

signal stats_changed(delta_stats: StatsSpecifier, delta_balance: int)
signal player_zero_health()
signal reload_ui()
signal update_item_slots()
signal add_attack_hover(position: Vector2, attack: Attack)
signal remove_attack_hover()

signal sound_effect(name: String)
signal sound_music(name: String)

signal combat_enter()
signal combat_exit(to_free: Node)
