extends Enemy

func start_talking() -> void:
    _current_state = State.TALK
    enable_outline(Color(0, 0, 1, 1))

func _on_animated_sprite_2d_animation_finished() -> void:
    if _sprite.animation == "idle2":
        _sprite.play("idle")
    elif _sprite.animation == "battle_intro":
        _sprite.play("battle_idle")

func _on_animated_sprite_2d_animation_looped() -> void:
    if _sprite.animation == "idle":
        if randi() % 5 == 3:
            _sprite.play("idle2")
