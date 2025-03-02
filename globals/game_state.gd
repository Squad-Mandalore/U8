class_name GameState
extends Resource

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://globals/game_state.gd"

@export var run_state: RunState
@export var current_station:  int
@export var times_played: int

@export var balance: int:
    set(value):
        balance = max(0, value)
@export var cur_inventory_size: int = 4
@export var meta_inventory_slots: Array[MetaItem]

static func get_run_state() -> RunState:
    var game_state = get_game_state()
    if not game_state.run_state:
        game_state.run_state = RunState.new()
    return game_state.run_state

static func new_run_state() -> RunState:
    var game_state = get_game_state()
    game_state.run_state = RunState.new()
    return game_state.run_state

static func has_game_state() -> bool:
    return GlobalState.has_state(STATE_NAME)

static func get_game_state() -> GameState:
    return GlobalState.get_state(STATE_NAME, FILE_PATH)

static func get_current_station() -> int:
    var game_state = get_game_state()
    if not game_state:
        return 0
    return game_state.current_station

static func set_current_station(station_number: int):
    var game_state = get_game_state()
    if not game_state:
        return
    game_state.current_station = station_number
    GlobalState.save()

static func start_game():
    var game_state = get_game_state()
    if not game_state:
        return
    game_state.times_played += 1
    GlobalState.save()

static func set_balance(balance: int):
    var game_state = get_game_state()
    if not game_state:
        return
    game_state.balance = balance
    GlobalState.save()

static func set_current_inv_size(size: int):
    var game_state = get_game_state()
    if not game_state:
        return
    game_state.cur_inventory_size = size
    GlobalState.save()

static func get_balance() -> int:
    var game_state = get_game_state()
    if not game_state:
        return 0
    return game_state.balance

static func get_current_inv_size() -> int:
    var game_state = get_game_state()
    if not game_state:
        return 4
    return game_state.cur_inventory_size

static func get_meta_inventory_slots() -> Array[MetaItem]:
    print("get meta inventory")
    var game_state = get_game_state()
    print(game_state)
    if not game_state:
        var inv: Array[MetaItem] = []
        inv.resize(7)
        inv.fill(null)
        return inv
    if len(game_state.meta_inventory_slots) == 0:
        var inv: Array[MetaItem] = []
        inv.resize(7)
        inv.fill(null)
        return inv
    return game_state.meta_inventory_slots

static func set_meta_inventory_slots(inv: Array[MetaItem]):
    print("set meta inventory")
    var game_state = get_game_state()
    if not game_state:
        print("default set meta inv")
        return
    game_state.meta_inventory_slots = inv
    GlobalState.save()

