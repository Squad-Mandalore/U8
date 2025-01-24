extends Node
class_name SourceOfTruth

static var _run_state = GameState.get_run_state()
static var _game_state = GameState.get_game_state()
static var stats: Class:
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
    stats.add(delta_stats)
    set_damage_for_all_attacks()
    SignalDispatcher.reload_ui.emit()

static func balance_changed(delta_balance: int):
    balance += delta_balance
    SignalDispatcher.reload_ui.emit()

# func damage(damage_taken: int):
#     stats.health -= damage_taken
#     SignalDispatcher.stats_changed.emit(stats, balance)

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
            stats_changed(ephemeral_item.stats.negate())
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
        attack.damage = calculate_damage(attack.formula)
        print(attack.damage)
    for item in inventory_slots:
        if item is Weapon:
            item.attack.damage = calculate_damage(item.attack.formula)
            print(item.attack.damage)

static func calculate_damage(formula: Formula):
    return (
        stats.max_health * formula.max_health_modifier +
        stats.health * formula.health_modifier +
        stats.armor * formula.armor_modifier +
        stats.initiative * formula.initiative_modifier +
        stats.dodge_chance * formula.dodge_chance_modifier +
        stats.strength * formula.strength_modifier +
        stats.coolness * formula.coolness_modifier +
        stats.attractiveness * formula.attractiveness_modifier +
        stats.intelligence * formula.intelligence_modifier +
        stats.creativity * formula.creativity_modifier +
        stats.luck * formula.luck_modifier +
        stats.poison_resistance * formula.poison_resistance_modifier +
        stats.bleed_resistance * formula.bleed_resistance_modifier +
        stats.drug_resistance * formula.drug_resistance_modifier +
        stats.poison_level * formula.poison_level_modifier +
        stats.bleed_level * formula.bleed_level_modifier +
        stats.drug_level * formula.drug_level_modifier
    ) * formula.effect_modifier + formula.effect_flat_modifier + formula.base

