extends CharacterBody2D
class_name NPC

enum State {IDLE, WALK, TALK}

var _current_state: State = State.IDLE
var _player_nearby: bool = false


@onready var _sprite = $AnimatedSprite2D
@export var _name : String = "Random Dude"
@export var RANDOM_NAME : bool = true
@export_enum("Male", "Female", "Diverse") var _gender : String
const outline_shader = preload("res://characters/npcs/assets/npc.gdshader")

func _ready() -> void:
    _current_state = State.IDLE
    if RANDOM_NAME:
        _name = NameGenerator.get_random_name(_gender)


func start_talking() -> void:
    _current_state = State.TALK
    enable_outline(Color(0, 0, 1, 1))

func stop_talking() -> void:
    _current_state = State.IDLE
    enable_outline(Color(0, 1, 0, 1))

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
