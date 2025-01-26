extends Npc
class_name WalkingNpc

@export var movement_speed: float = 68.0
var _direction: Vector2 = Vector2.ZERO
@onready var _timer = $Timer

enum SubState { NONE, MAKE_SPACE, WALK }
var _sub_state = SubState.NONE

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

    if _direction != Vector2.ZERO or _sub_state == SubState.MAKE_SPACE:
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
    super.start_talking()
    _timer.stop()
    velocity = Vector2.ZERO
    _direction = Vector2.ZERO
    _sub_state = SubState.NONE

func stop_talking() -> void:
    super.stop_talking()
    _sub_state = SubState.NONE
    _timer.start(1.0)

func _new_direction() -> void:
    _direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))

func _new_state() -> void:
    # Don’t interrupt forced moves
    if _sub_state == SubState.MAKE_SPACE:
        return

    if _current_state == State.IDLE:
        _sub_state = SubState.WALK
        _new_direction()
        _timer.start(1.0)
    else:
        _current_state = State.IDLE
        _direction = Vector2.ZERO
        _timer.start(5.0)

func set_player_nearby(is_player_nearby : bool):
    _player_nearby = is_player_nearby

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
func make_space(_body: Node2D) -> void:
    if _current_state == State.TALK:
        return

    var valid_dir = pick_valid_direction()
    if valid_dir != Vector2.ZERO:
        _direction = valid_dir
        _sub_state = SubState.WALK
        _sub_state = SubState.MAKE_SPACE
        # Move for half a second
        _timer.start(0.5)
