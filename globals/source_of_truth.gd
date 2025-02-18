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
    if stats.health <= 0:
        SignalDispatcher.player_zero_health.emit()
        GameState.new_run_state()
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
            player_attacks.append_array(item.attacks)
    return player_attacks

static func set_damage_for_all_attacks():
    for attack in stats.attacks:
        attack.calculate_damage(stats)
    for item in inventory_slots:
        if item is Weapon:
            for attack in item.attacks:
                attack.calculate_damage(stats)

# Funciton gets a percentage and returns TRUE or FALSE dependant on the outcome
static func chance(percent: float) -> bool:
    return randf() * 100 < percent

# AttackTypes and their effectiveness against each other
static var effectiveness = {
    Utils.AttackTypes.Stark: {Utils.AttackTypes.Attraktiv: 2.0, Utils.AttackTypes.Cool: 0.5},
    Utils.AttackTypes.Attraktiv: {Utils.AttackTypes.Cool: 2.0, Utils.AttackTypes.Stark: 0.5},
    Utils.AttackTypes.Cool: {Utils.AttackTypes.Stark: 2.0, Utils.AttackTypes.Attraktiv: 0.5},
    Utils.AttackTypes.Kreativ: {Utils.AttackTypes.Intelligent: 2.0},
    Utils.AttackTypes.Intelligent: {Utils.AttackTypes.Kreativ: 2.0}
}

# Function to determine attack effectiveness
static func get_effectiveness_value(attacker_type:  Utils.AttackTypes, defender_type:  Utils.AttackTypes) -> float:
    if attacker_type in effectiveness and defender_type in effectiveness[attacker_type]:
        return effectiveness[attacker_type][defender_type]
    return 1.0 # Neutral if no special effectiveness

static func calculate_dmg_with_armor(armor: int, damage: int) -> int:
    if armor == 0:
        return damage
    return max(0, damage - 1.04274 * armor + 5 * log(exp(armor / 5) + 148.413) - 25)

static func calculate_damage(damage: int, defender_stats: StatsSpecifier, attacker_token: Utils.AttackTypes, defender_token: Utils.AttackTypes) -> int:
    if chance(defender_stats.dodge_chance):
        return 0

    # check for effective attack
    damage *= get_effectiveness_value(attacker_token, defender_token)

    # apply armor to dmg
    damage = calculate_dmg_with_armor(defender_stats.armor, damage)
    return damage

static func calculate_selling_price(price: int) -> int:
    return price * 0.7
