extends Node
class_name SourceOfTruth

static var stats: Class:
    set(value):
        RunState.set_stats(value)
    get():
        return RunState.get_stats()

static var balance: int:
    set(value):
        GameState.set_balance(value)
    get():
        return GameState.get_balance()

static var inventory_slots: Array[Item]:
    set(value):
        RunState.set_inventory_slots(value)
    get():
        return RunState.get_inventory_slots()

static var cur_inventory_size: int:
    set(value):
        GameState.set_current_inv_size(value)
    get():
        return GameState.get_current_inv_size()

static var in_shop: bool = false

const MAX_INVENTORY_SIZE: int = 16

static func stats_changed(delta_stats: StatsSpecifier):
    stats.add(delta_stats)
    set_damage_for_all_attacks()
    SignalDispatcher.reload_ui.emit()

static func balance_changed(delta_balance: int):
    balance += delta_balance
    SignalDispatcher.reload_ui.emit()

static func add_item(item: Item):
    # TODO: else case
    for i in range(cur_inventory_size):
        if inventory_slots[i] == null:
            inventory_slots[i] = item
            stats_changed(item.stats)
            return

static func remove_item(i: int):
    if i < len(inventory_slots):
        if inventory_slots[i] != null:
            var ephemeral_item = inventory_slots[i]
            inventory_slots[i] = null
            var negated_stats = ephemeral_item.stats.negate()
            stats_changed(negated_stats)
        return

static func swap_item(from: int, to: int):
    var tmp = inventory_slots[from]
    inventory_slots[from] = inventory_slots[to]
    inventory_slots[to] = tmp
    SignalDispatcher.reload_ui.emit()

static func get_all_attacks() -> Array[Attack]:
    var player_attacks = stats.attacks.duplicate()
    for item in inventory_slots:
        if item is Weapon:
            player_attacks.append(item.attack)
    return player_attacks

static func set_damage_for_all_attacks():
    for attack in stats.attacks:
        attack.calculate_damage(stats)
    for item in inventory_slots:
        if item is Weapon:
            item.attack.calculate_damage(stats)

static func calculate_damage(damage: int, stats: StatsSpecifier) -> int:
    # crazy damage calculation function here
    return damage

static func calculate_selling_price(price: int) -> int:
    return price * 0.7
