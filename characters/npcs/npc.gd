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

# function for schackeline, perhaps use for player if stuck as well
func make_space(body : Node2D) -> void:
    # Moves the npc out of the center of the train
    var move_direction = Vector2.ZERO

    # Check if moving up is possible
    var up_position = global_position + Vector2(0, -10)
    if not is_position_obstructed(up_position):
        move_direction = Vector2(0, -1)
    else:
        # Check if moving down is possible
        var down_position = global_position + Vector2(0, 10)
        if not is_position_obstructed(down_position):
            move_direction = Vector2(0, 1)
        else:
            # Move back in X direction to create space
            var back_position = global_position + Vector2(10, 0)
            if not is_position_obstructed(back_position):
                move_direction = Vector2(1, 0)
            else:
                move_direction = Vector2(-1, 0)

    position += move_direction * 5

func is_position_obstructed(target_position: Vector2) -> bool:
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsRayQueryParameters2D.create(global_position, target_position)
    var result = space_state.intersect_ray(query)
    return result.size() > 0
