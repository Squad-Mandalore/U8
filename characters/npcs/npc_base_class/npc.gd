extends CharacterBody2D
class_name NPC

enum State {IDLE, WALK, TALK}
const SPEED: float = 68.0

var _direction: Vector2 = Vector2.ZERO
var _current_state: State = State.IDLE
var _talking: bool = false
var _player_nearby: bool = false


@onready var _sprite = $AnimatedSprite2D
@onready var _timer = $Timer
@export var _name : String = "Random Dude"
@export var RANDOM_NAME : bool = true
@export_enum("Male", "Female", "Diverse") var _gender : String 
const outline_shader = preload("res://assets/npcs/npc.gdshader")

func _ready() -> void:
	_new_state()
	if RANDOM_NAME:
		_name = NameGeneratorNode.get_random_name(_gender)


func _physics_process(delta: float) -> void:
	if _current_state == State.TALK:
		# If _talking, stay idle
		_sprite.play("idle")
		return

	var speed = SPEED
	if _player_nearby:
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

func start_talking() -> void:
	_talking = true
	_timer.stop()
	velocity = Vector2.ZERO
	_direction = Vector2.ZERO
	_current_state = State.TALK
	enable_outline(Color(0, 0, 1, 1))

func stop_talking() -> void:
	_talking = false
	_current_state = State.IDLE
	# Resume normal walking after a small delay or immediately
	_timer.start(1.0)
	enable_outline(Color(0, 1, 0, 1))


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
		
func enable_outline(color : Color = Color(0, 1, 0, 1)) -> void:
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
		
func set_player_nearby(is_player_nearby : bool):
	_player_nearby = is_player_nearby
		
func disable_outline() -> void:
	_sprite.material = null

func _on_timer_timeout() -> void:
	if _current_state != State.TALK:
		_new_state()