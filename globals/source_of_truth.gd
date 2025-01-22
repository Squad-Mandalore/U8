extends Node

var stats: StatsSpecifier = load("res://characters/player/classes/honest_burgy.tres")

var balance: int

var inventory_slots: Array[Item]
var cur_inventory_size: int = 4
var max_inventory_size: int = 16

func _ready() -> void:
    inventory_slots.resize(max_inventory_size)
    inventory_slots.fill(null)

func stats_changed(delta_stats: StatsSpecifier):
    # print("Before: " + str(self.stats))
    self.stats.add(delta_stats)
    # print("After: " + str(self.stats))
    SignalDispatcher.reload_ui.emit(self.stats, self.balance)
    # SignalDispatcher.update_status_panel_stat.emit(self.stats, self.balance)

func balance_changed(delta_balance: int):
    self.balance += delta_balance
    SignalDispatcher.reload_ui.emit(self.stats, self.balance)

# func damage(damage_taken: int):
#     stats.health -= damage_taken
#     SignalDispatcher.stats_changed.emit(stats, balance)

# func reset_stats():
#     self.stats = base_stats.duplicate()

func add_item(item: Item):
    # TODO: else case
    for i in range(cur_inventory_size):
        if inventory_slots[i] == null:
            inventory_slots[i] = item
            stats_changed(item.properties)
            return

func remove_item(i: int):
    if i < len(inventory_slots):
        if inventory_slots[i] != null:
            var ephemeral_item = inventory_slots[i]
            inventory_slots[i] = null
            stats_changed(ephemeral_item.properties.negate())
        return

func swap_item(from: int, to: int):
    var tmp = inventory_slots[from]
    inventory_slots[from] = inventory_slots[to]
    inventory_slots[to] = tmp
    SignalDispatcher.reload_ui.emit(self.stats, self.balance)
