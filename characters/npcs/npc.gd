extends CharacterBody2D
class_name Npc

enum State {IDLE, TALK}

var _current_state: State = State.IDLE
var _player_nearby: Player = null

@onready var _sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var _name : String = "Random Dude"
@export var _random_name : bool = true
@export_enum("Male", "Female", "Diverse") var _gender : String
const outline_shader = preload("res://characters/npcs/assets/npc.gdshader")

func _ready() -> void:
    _current_state = State.IDLE
    if _random_name:
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

func set_player_nearby(is_player_nearby : Player):
    _player_nearby = is_player_nearby

func disable_outline() -> void:
    _sprite.material = null

# function for schackeline, perhaps use for player if stuck as well
func make_space(body : Node2D) -> void:
    # Moves the npc out of the center of the train
    position += pick_valid_direction() * 5

func is_position_obstructed(target_position: Vector2) -> bool:
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsRayQueryParameters2D.create(global_position, target_position)
    var result = space_state.intersect_ray(query)
    return result.size() > 0

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

func start_animation(animation: String):
    _sprite.animation = animation
    _sprite.play()

func stop_animation():
    _sprite.stop()
