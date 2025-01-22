extends LevelListManager

func set_current_level_id(value):
    super.set_current_level_id(value)
    GameState.set_current_station(value)

func get_current_level_id() -> int:
    current_level_id = GameState.get_current_station() if force_level == -1 else force_level
    return current_level_id

func _advance_level():
    super._advance_level()
    GameState.set_current_station(current_level_id)
