extends TrainStationNpc
class_name TrashCanExtinguisher

func _on_target_reached() -> void:
    if _current_target:
        _start_action(_current_target.global_position)
    else:
        super._on_target_reached()

func _start_action(target_point: Vector2) -> void:
    _action_in_progress = true
    velocity = Vector2.ZERO
    nav_agent.velocity = Vector2.ZERO

    _sprite.flip_h = global_position.x > target_point.x
    _sprite.play("action")

func _on_animated_sprite_2d_animation_finished() -> void:
    if _sprite.animation == "action":
        if _current_target:
            var seating = _current_target.get_parent()
            if seating.has_method("extinguish_fire"):
                seating.extinguish_fire()
            if seating.has_method("extinguish_fire2"):
                seating.extinguish_fire2()

        _current_target = null

    _action_in_progress = false
    _idling = true
    _sprite.play("idle")
    await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
    _idling = false
    set_new_random_target()

func set_new_random_target() -> void:
    if not _map_ready:
        return

    var fire = get_closest_fire()
    if fire:
        _current_target = fire
        var _target_position = get_valid_extinguishing_position(fire)

        nav_agent.target_position = _target_position
        return

    super.set_new_random_target()

func get_valid_extinguishing_position(fire: Node2D) -> Vector2:
    var maps = NavigationServer2D.get_maps()
    var offset_x = -10 if fire.name.to_lower().contains("fire") else 10  # Left fire (-10px), right fire (+10px)
    var target_point = NavigationServer2D.map_get_closest_point(maps[0], fire.global_position + Vector2(offset_x, 0))
    return target_point

func get_closest_fire() -> Node2D:
    if not is_inside_tree():
        return null

    var fires = []
    for seating in get_tree().get_nodes_in_group("SeatingArea"):
        if seating._fire_left.visible:
            fires.append(seating._fire_left)
        if seating._fire_right.visible:
            fires.append(seating._fire_right)

    if fires.is_empty():
        return null

    fires.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
    return fires[randi_range(0, clampi(abs(fires.size() / 2), 0, fires.size()))]
