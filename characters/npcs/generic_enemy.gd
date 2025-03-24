extends Enemy

func set_player_nearby(is_player_nearby : Player):
    super.set_player_nearby(is_player_nearby)
    if _player_nearby:
        start_combat()
