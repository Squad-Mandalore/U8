extends CharacterBody2D
class_name NPC

enum State {IDLE, WALK}
const SPEED: float = 68.0
var _direction: Vector2 = Vector2.ZERO
var _current_state: State = State.IDLE
var _slowdown_entities: int = 0

@onready var _sprite = $AnimatedSprite2D
@onready var _timer = $Timer
@onready var slowdown_area = $SlowdownArea


func _ready() -> void:
    _new_state()


func _physics_process(_delta: float) -> void:
    if _direction.x < 0:
        _sprite.flip_h = true
    elif _direction.x > 0:
        _sprite.flip_h = false

    var speed = SPEED
    if _slowdown_entities > 0:
        speed = SPEED / 2

    if _direction:
        velocity = _direction * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.y = move_toward(velocity.y, 0, speed)
    if velocity:
        _sprite.play("walk")
    else:
        _sprite.play("idle")

    move_and_slide()


func _new_direction() -> void:
    _direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))

func _new_state() -> void:
    if _current_state == State.IDLE:
        _current_state = State.WALK
        _new_direction()
        _timer.start(1.0)
    else:
        _current_state = State.IDLE
        _direction = Vector2.ZERO
        _timer.start(5.0)


func _on_timer_timeout() -> void:
    _new_state()



func _on_slowdown_area_body_entered(body: Node2D):
    if body.is_in_group("Player"):
        _slowdown_entities = _slowdown_entities + 1

func _on_slowdown_area_body_exited(body: Node2D):
    if body.is_in_group("Player"):
        _slowdown_entities = _slowdown_entities - 1
