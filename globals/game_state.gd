class_name GameState
extends Resource

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://globals/game_state.gd"

@export var level_states : Dictionary = {}
@export var current_station : int
@export var times_played : int

static func get_level_state(level_state_key : String) -> LevelState:
	var game_state = get_game_state()
	if level_state_key.is_empty() : return
	if level_state_key in game_state.level_states:
		return game_state.level_states[level_state_key]
	else:
		var new_level_state = LevelState.new()
		game_state.level_states[level_state_key] = new_level_state
		return new_level_state

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
