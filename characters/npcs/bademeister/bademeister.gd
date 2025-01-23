extends BOSS

# DEBUG
func enable_outline(color : Color = Color(1, 0, 0, 1)) -> void:
    _sprite.play("battle_intro")
    # Create and assign a ShaderMaterial with the given outline shader
    if outline_shader:
        var mat = ShaderMaterial.new()
        mat.shader = outline_shader
        # Adjust parameters as needed
        mat.set_shader_parameter("outline_thickness", 0.5)
        mat.set_shader_parameter("outline_color", color)
        _sprite.material = mat
    else:
        # No shader assigned
        _sprite.material = null

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("talk"):
        SignalDispatcher.combat_enter.emit()

func _on_animated_sprite_2d_animation_finished() -> void:
    if _sprite.animation == "idle2":
        _sprite.play("idle")
    elif _sprite.animation == "battle_intro":
        _sprite.play("battle_idle")

func _on_animated_sprite_2d_animation_looped() -> void:
    if _sprite.animation == "idle":
        if randi() % 5 == 3:
            _sprite.play("idle2")
