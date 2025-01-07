class_name Player
extends CharacterBody2D


const SPEED: float = 102.0

@onready var _animated_sprite_2d = $AnimatedSprite2D
enum State {IDLE, WALK, TALK}
var _current_state: State = State.IDLE

func _physics_process(_delta: float) -> void:
	if _current_state == State.TALK:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction.x < 0:
		_animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		_animated_sprite_2d.flip_h = false

	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity:
		switch_state(State.WALK)
	else:
		switch_state(State.IDLE)

	move_and_slide()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("talk"):
		switch_state(State.TALK)
		
func switch_state(new_state: State):
	if _current_state == new_state and new_state == State.TALK:
		new_state = State.IDLE
	if new_state != _current_state:
		_current_state = new_state
		if _current_state == State.TALK:
			_animated_sprite_2d.play("talk")
		if _current_state == State.WALK:
			_animated_sprite_2d.play("walk")
		if _current_state == State.IDLE:
			_animated_sprite_2d.play("idle")
