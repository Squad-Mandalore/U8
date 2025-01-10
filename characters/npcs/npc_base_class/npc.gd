extends CharacterBody2D
class_name NPC

enum State {IDLE, WALK, TALK}
const SPEED: float = 68.0

var _direction: Vector2 = Vector2.ZERO
var _current_state: State = State.IDLE
var _slowdown_entities: int = 0:
    set(value):
        _slowdown_entities = max(value, 0)
var _talking: bool = false

@onready var _sprite = $AnimatedSprite2D
@onready var _timer = $Timer
@onready var _rich_text_label = $RichTextLabel

signal talk_started(npc: NPC)
signal talk_stopped(npc: NPC)

func _ready() -> void:
    _new_state()

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK:
        # If _talking, stay idle
        _sprite.play("idle")
        return

    var speed = SPEED
    if _slowdown_entities > 0:
        speed = SPEED / 2

    if _direction.x < 0:
        _sprite.flip_h = true
    elif _direction.x > 0:
        _sprite.flip_h = false

    if _direction != Vector2.ZERO:
        velocity = _direction * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.y = move_toward(velocity.y, 0, speed)

    if velocity.length() > 0.1:
        _sprite.play("walk")
    else:
        _sprite.play("idle")

    # Changed to move_and_collide instead of move_and_slide
    # As slide thing caused the sticking to each other bug
    move_and_collide(velocity * delta)

func _start_talking() -> void:
    # This function sends a notification to Player script so that Player can talk to this npc.
    _talking = true
    _timer.stop()
    velocity = Vector2.ZERO
    _direction = Vector2.ZERO
    _current_state = State.TALK

func _stop_talking() -> void:
    # This function needs to be called in order for player character to be able to walk again.
    _talking = false
    _current_state = State.IDLE
    # Resume normal walking after a small delay or immediately
    _timer.start(1.0)

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
    if _current_state != State.TALK:
        _new_state()

func _on_slowdown_area_body_entered(body: Node2D):
    # If the Player enters this NPC's slowdown area, NPC speed is halved
    _slowdown_entities += 1
    _rich_text_label.visible = true
    var player: Player = body
    if not player.is_connected("talk_started", _on_player_talk_started):
        player.connect("talk_started", _on_player_talk_started)

    if not player.is_connected("talk_stopped", _on_player_talk_started):
        player.connect("talk_stopped", _on_player_talk_stopped)

func _on_slowdown_area_body_exited(body: Node2D):
    # If the Player leaves, restore normal speed (if no more slowdown entities)
    _slowdown_entities -= 1
    if _slowdown_entities == 0:
        _rich_text_label.visible = false
    var player: Player = body
    if player.is_connected("talk_started", _on_player_talk_started):
        player.disconnect("talk_started", _on_player_talk_started)

    if player.is_connected("talk_stopped", _on_player_talk_started):
        player.disconnect("talk_stopped", _on_player_talk_stopped)


func _on_player_talk_started(_player: Player):
    _start_talking()


func _on_player_talk_stopped(_player: Player):
    _stop_talking()
