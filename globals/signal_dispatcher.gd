extends Node

signal toggle_item_hud(new_item: Item, is_shop_slot: bool)
signal toggle_resistance_hud(stats: StatsSpecifier)
signal toggle_status_types_hud(stats: StatsSpecifier)

signal swap_inventory_items(from: int, to: int)
signal set_ck3_progress_bar_value(value: int)

signal player_zero_health()
signal reload_ui()
signal update_item_slots()
signal update_shop_item_slots(to_free: int)
signal add_attack_hover(position: Vector2, attack: Attack)
signal remove_attack_hover()
signal update_shop_dialogue_box(item: Item)

signal sound_effect(name: String)
signal sound_music(name: String)

signal combat_enter(enemy: Enemy)
signal combat_exit(to_free: Node)

signal execute_attack(attack: Attack, active_combatant: String, passive_combatant: String)

