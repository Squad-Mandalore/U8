extends TrainStationNpc
class_name SmokingDude

var _current_trashcan: SeatingArea = null
var _smoking_side: String = ""
var _target_position: Vector2 = Vector2.ZERO

@onready var _smoke: GPUParticles2D = $smoke

func _on_target_reached() -> void:
    if _current_trashcan:
        _start_smoking()
    else:
        super._on_target_reached()

func _start_smoking() -> void:
    _action_in_progress = true
    velocity = Vector2.ZERO
    nav_agent.velocity = Vector2.ZERO

    _sprite.flip_h = (_smoking_side == "left")
    if _smoking_side == "left":
        _smoke.position = Vector2(-6.0, -24)
    else:
        _smoke.position = Vector2(6.0, -24)

    _sprite.play("idle2")
    await Utils.create_timer(3.0)

    _sprite.play("idle3")
    _smoke.show()

    await Utils.create_timer(randf_range(10.0, 20.0))
    _smoke.hide()

    _sprite.play("action")

func _on_animated_sprite_2d_animation_finished() -> void:
    if _sprite.animation == "action":
        if _current_trashcan:
            if _smoking_side == "left":
                _current_trashcan.activate_fire()
            else:
                _current_trashcan.activate_fire2()

        _current_trashcan = null

        _action_in_progress = false
        _idling = true

        _sprite.stop()
        _sprite.play("idle")

        await Utils.create_timer(randf_range(2.0, 5.0))

        _idling = false
        set_new_random_target()

func set_new_random_target() -> void:
    if not _map_ready or _action_in_progress or _idling:
        return

    if randi_range(0,2) == 1:
        var trashcan = get_closest_empty_trashcan()
        if trashcan:
            _current_trashcan = trashcan
            _target_position = get_valid_smoking_position(trashcan)

            nav_agent.target_position = _target_position
            return

    super.set_new_random_target()

func get_valid_smoking_position(trashcan: SeatingArea) -> Vector2:
    var nearby_offset = Vector2(randf_range(-20, 20), randf_range(-10, 10))
    if not trashcan._fire_left.visible:
        _smoking_side = "left"
        var maps = NavigationServer2D.get_maps()
        var target_point = NavigationServer2D.map_get_closest_point(maps[0], trashcan._fire_left.global_position + nearby_offset)
        return target_point
    elif not trashcan._fire_right.visible:
        _smoking_side = "right"
        var maps = NavigationServer2D.get_maps()
        var target_point = NavigationServer2D.map_get_closest_point(maps[0], trashcan._fire_left.global_position - nearby_offset)
        return target_point
    return trashcan.global_position

func get_closest_empty_trashcan() -> SeatingArea:
    if not get_tree():
        return
    var trashcans = []

    for seating in get_tree().get_nodes_in_group("SeatingArea"):
        if not seating._fire_left.visible and not seating._fire_right.visible:
            trashcans.append(seating)

    if trashcans.is_empty():
        return null

    trashcans.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
    return trashcans[randi_range(0, clampi(abs(trashcans.size() / 2), 0, trashcans.size()))]
