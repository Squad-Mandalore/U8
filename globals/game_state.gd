class_name GameState
extends Resource

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://globals/game_state.gd"

@export var run_state : RunState = RunState.new()
@export var current_station : int
@export var times_played : int

@export var balance: int = 0
@export var cur_inventory_size: int = 4

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
    for item: Item in game_state.run_state.inventory_slots:
        if item:
            game_state.run_state.stats.add(item.properties)
    GlobalState.save()
