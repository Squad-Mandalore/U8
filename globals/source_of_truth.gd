extends Node
class_name SourceOfTruth

static var _run_state = GameState.get_run_state()
static var _game_state = GameState.get_game_state()
static var stats: StatsSpecifier:
    set(value):
        _run_state.stats = value
    get():
        return _run_state.stats

static var balance: int:
    set(value):
        _game_state.balance = value
    get():
        return _game_state.balance

static var inventory_slots: Array[Item]:
    set(value):
        _run_state.inventory_slots = value
    get():
        return _run_state.inventory_slots
static var cur_inventory_size: int:
    set(value):
        _game_state.cur_inventory_size = value
    get():
        return _game_state.cur_inventory_size
const MAX_INVENTORY_SIZE: int = 16

static func stats_changed(delta_stats: StatsSpecifier):
    # print("Before: " + str(stats))
    stats.add(delta_stats)
    # print("After: " + str(stats))
    SignalDispatcher.reload_ui.emit(stats, balance)
    # SignalDispatcher.update_status_panel_stat.emit(stats, balance)

static func balance_changed(delta_balance: int):
    balance += delta_balance
    SignalDispatcher.reload_ui.emit(stats, balance)

# func damage(damage_taken: int):
#     stats.health -= damage_taken
#     SignalDispatcher.stats_changed.emit(stats, balance)

# func reset_stats():
#     stats = base_stats.duplicate()

static func add_item(item: Item):
    # TODO: else case
    for i in range(cur_inventory_size):
        if inventory_slots[i] == null:
            inventory_slots[i] = item
            stats_changed(item.properties)
            return

static func remove_item(i: int):
    if i < len(inventory_slots):
        if inventory_slots[i] != null:
            var ephemeral_item = inventory_slots[i]
            inventory_slots[i] = null
            stats_changed(ephemeral_item.properties.negate())
        return

static func swap_item(from: int, to: int):
    var tmp = inventory_slots[from]
    inventory_slots[from] = inventory_slots[to]
    inventory_slots[to] = tmp
    SignalDispatcher.reload_ui.emit(stats, balance)
