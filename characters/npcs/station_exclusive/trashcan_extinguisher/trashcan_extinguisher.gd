extends Npc
class_name TrashCanExtinguisher

@export var movement_speed: float = 60.0 
@export var max_roam_distance: float = 200.0
@export var navigation_layers: int = 1

var _direction: Vector2 = Vector2.ZERO
var _current_fire: Node2D = null
var _action_in_progress: bool = false
var _map_ready: bool = false
var _idling: bool = false

@onready var _timer: Timer = $Timer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
    super._ready()
    _timer.start(randf_range(10.0, 25.0))
    call_deferred("_initialize_navigation")

    NavigationServer2D.connect("map_changed", Callable(self, "_on_map_ready"))
    nav_agent.connect("target_reached", Callable(self, "_on_target_reached"))
    nav_agent.connect("path_changed", Callable(self, "_on_path_changed"))
    nav_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))

    nav_agent.path_desired_distance = 1.0
    nav_agent.target_desired_distance = 0.5
    nav_agent.max_speed = movement_speed
    nav_agent.radius = 200

func _initialize_navigation() -> void:
    var nav_map: RID = nav_agent.get_navigation_map()
    
    while NavigationServer2D.map_get_iteration_id(nav_map) == 0:
        await NavigationServer2D.map_changed

    _map_ready = true
    set_new_random_target()

func _on_map_ready(_something = null) -> void:
    if not _map_ready:
        _map_ready = true
        set_new_random_target()

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK or _action_in_progress or _idling or not _map_ready:
        velocity = Vector2.ZERO
        nav_agent.velocity = Vector2.ZERO
        return

    var fire = get_closest_fire()
    if fire and not _action_in_progress:
        _current_fire = fire
        var adjusted_position = fire.global_position

        if fire.name.to_lower().contains("fire2"):
            adjusted_position.x += 10
        else:
            adjusted_position.x -= 10
        adjusted_position.y += 16

        if nav_agent.target_position != adjusted_position:
            nav_agent.target_position = adjusted_position

    if not nav_agent.is_navigation_finished():
        var next_point = nav_agent.get_next_path_position()
        if next_point != Vector2.ZERO:
            _direction = (next_point - global_position).normalized()
        else:
            _direction = Vector2.ZERO

        if _direction.length() > 0.1:
            _sprite.flip_h = _direction.x < 0
            if _sprite.animation != "walk":
                _sprite.play("walk")
        else:
            if _sprite.animation != "idle":
                _sprite.play("idle")

        var computed_velocity = _direction * movement_speed
        nav_agent.velocity = computed_velocity

    if global_position.distance_to(nav_agent.target_position) < 5:
        if _current_fire:
            _start_action(nav_agent.target_position)
        else:
            _on_target_reached()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    if _idling or _action_in_progress:
        velocity = Vector2.ZERO
        nav_agent.velocity = Vector2.ZERO
        return

    if safe_velocity.length() > 0:
        velocity = safe_velocity
        move_and_slide()
    else:
        velocity = Vector2.ZERO
        nav_agent.velocity = Vector2.ZERO  # Stop when reaching target

func _start_action(target_point: Vector2) -> void:
    print("Starting fire extinguishing action.")
    _action_in_progress = true
    velocity = Vector2.ZERO
    nav_agent.velocity = Vector2.ZERO

    _sprite.flip_h = global_position.x > target_point.x

    _sprite.play("action")

func _on_animated_sprite_2d_animation_finished() -> void:
    if _sprite.animation == "action":
        if _current_fire:
            var seating = _current_fire.get_parent()
            if seating.has_method("extinguish_fire"):
                seating.extinguish_fire()
            if seating.has_method("extinguish_fire2"):
                seating.extinguish_fire2()
            _current_fire = null

        _action_in_progress = false
        _idling = true

        _sprite.stop()
        _sprite.play("idle")

        await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
        _idling = false
        set_new_random_target()
        _direction = Vector2.ZERO

func _on_target_reached() -> void:
    velocity = Vector2.ZERO
    nav_agent.velocity = Vector2.ZERO
    _idling = true
    _sprite.play("idle")
    await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
    _idling = false
    set_new_random_target()

func set_new_random_target() -> void:
    if not _map_ready:
        return

    var nav_map: RID = nav_agent.get_navigation_map()
    var new_target = NavigationServer2D.map_get_random_point(nav_map, navigation_layers, true)

    var attempts = 5
    while (global_position.distance_to(new_target) > max_roam_distance or new_target == Vector2.ZERO) and attempts > 0:
        new_target = NavigationServer2D.map_get_random_point(nav_map, navigation_layers, true)
        attempts -= 1

    if new_target == Vector2.ZERO:
        return

    nav_agent.target_position = new_target

func get_closest_fire() -> Node2D:
    var fires = []
    for seating in get_tree().get_nodes_in_group("SeatingArea"):
        if seating.has_node("Fire") and seating.get_node("Fire").visible:
            fires.append(seating.get_node("Fire"))
        if seating.has_node("Fire2") and seating.get_node("Fire2").visible:
            fires.append(seating.get_node("Fire2"))
    if fires.is_empty():
        return null
    
    var closest = fires[0]
    var min_dist = global_position.distance_to(closest.global_position)
    
    for fire in fires:
        var d = global_position.distance_to(fire.global_position)
        if d < min_dist:
            min_dist = d
            closest = fire
    return closest

func _on_path_changed() -> void:
    var next_point = nav_agent.get_next_path_position()
    _direction = (next_point - global_position).normalized()
