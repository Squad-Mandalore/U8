extends Npc
class_name TrainStationNpc

@export var movement_speed: float = 50.0
@export var max_roam_distance: float = 100.0
@export var navigation_layers: int = 1
@export var recalculation_interval: float = 2.0

var _direction: Vector2 = Vector2.ZERO
var _action_in_progress: bool = false
var _map_ready: bool = false
var _idling: bool = false
var _current_target: Node2D = null
var _recalculation_timer: Timer

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
    super._ready()
    call_deferred("_initialize_navigation")

    # Initialize the path recalculation timer
    _recalculation_timer = Timer.new()
    _recalculation_timer.wait_time = recalculation_interval
    _recalculation_timer.timeout.connect(_recalculate_path)
    _recalculation_timer.autostart = true
    add_child(_recalculation_timer)

    NavigationServer2D.map_changed.connect(_on_map_ready)
    nav_agent.target_reached.connect(_on_target_reached)
    nav_agent.velocity_computed.connect(_on_velocity_computed)
    nav_agent.max_speed = movement_speed

func _initialize_navigation() -> void:
    var nav_map: RID = nav_agent.get_navigation_map()
    await self.get_tree().create_timer(randf_range(2,6)).timeout
    while NavigationServer2D.map_get_iteration_id(nav_map) == 0:
        await NavigationServer2D.map_changed

    _map_ready = true
    set_new_random_target()

func _on_map_ready(_something = null) -> void:
    if not _map_ready:
        _map_ready = true
        set_new_random_target()

func _physics_process(delta: float) -> void:
    if _action_in_progress or _idling or not _map_ready:
        velocity = Vector2.ZERO
        nav_agent.velocity = Vector2.ZERO
        return

    if _current_target and global_position.distance_to(nav_agent.target_position) > 5:
        nav_agent.target_position = _current_target.global_position

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
        nav_agent.velocity = Vector2.ZERO

func _on_target_reached() -> void:
    if _current_target:
        return

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

func _recalculate_path() -> void:
    if not nav_agent.is_navigation_finished():
        nav_agent.target_position = nav_agent.target_position
