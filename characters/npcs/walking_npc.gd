extends NPC
class_name WALKING_NPC

@export var movement_speed: float = 68.0
var _direction: Vector2 = Vector2.ZERO
@onready var _timer = $Timer

enum SubState { NONE, MAKE_SPACE }
var _sub_state = SubState.NONE

func _ready() -> void:
    _new_state()
    if RANDOM_NAME:
        _name = NameGenerator.get_random_name(_gender)

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK:
        _sprite.play("idle")
        return

    var speed = movement_speed
    if _player_nearby:
        speed = movement_speed / 2

    if _direction.x < 0:
        _sprite.flip_h = true
    elif _direction.x > 0:
        _sprite.flip_h = false

    if _sub_state == SubState.MAKE_SPACE:
        velocity = _direction * speed
    else:
        if _direction != Vector2.ZERO:
            velocity = _direction * speed
        else:
            velocity.x = move_toward(velocity.x, 0, speed)
            velocity.y = move_toward(velocity.y, 0, speed)

    if velocity.length() > 0.1:
        _sprite.play("walk")
    else:
        _sprite.play("idle")

    move_and_collide(velocity * delta)

func start_talking() -> void:
    _timer.stop()
    velocity = Vector2.ZERO
    _direction = Vector2.ZERO
    _current_state = State.TALK
    _sub_state = SubState.NONE
    enable_outline(Color(0, 0, 1, 1))

func stop_talking() -> void:
    _current_state = State.IDLE
    _sub_state = SubState.NONE
    _timer.start(1.0)
    enable_outline(Color(0, 1, 0, 1))

func _new_direction() -> void:
    _direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))

func _new_state() -> void:
    # Don’t interrupt forced moves
    if _sub_state == SubState.MAKE_SPACE:
        return

    if _current_state == State.IDLE:
        _current_state = State.WALK
        _new_direction()
        _timer.start(1.0)
    else:
        _current_state = State.IDLE
        _direction = Vector2.ZERO
        _timer.start(5.0)

func set_player_nearby(is_player_nearby : bool):
    _player_nearby = is_player_nearby

func disable_outline() -> void:
    _sprite.material = null

func _on_timer_timeout() -> void:
    if _current_state == State.TALK:
        return

    # If we were making space, revert sub-state afterwards
    if _sub_state == SubState.MAKE_SPACE:
        _sub_state = SubState.NONE
        _new_state()
    else:
        _new_state()

# Changed make_space to pick a direction and walk for a bit
func make_space(body : Node2D) -> void:
    if _current_state == State.TALK:
        return

    var valid_dir = pick_valid_direction()
    if valid_dir != Vector2.ZERO:
        _direction = valid_dir
        _current_state = State.WALK
        _sub_state = SubState.MAKE_SPACE
        # Move for half a second
        _timer.start(0.5)

# Helper to find an unobstructed direction
func pick_valid_direction() -> Vector2:
    var directions = [
        Vector2(0, -1),
        Vector2(0, 1),
        Vector2(-1, 0),
        Vector2(1, 0)
    ]
    directions.shuffle()

    for dir in directions:
        var check_pos = global_position + dir * 24
        if not is_position_obstructed(check_pos):
            return dir

    return Vector2.ZERO
