extends Npc
class_name SeatedNpc

@onready var _sprite_2d: Sprite2D = $Sprite2D
@export var _textures_path : String = "res://characters/npcs/seated/pointed_away/assets/"

func subclass_ready():
    if randi_range(0,5) == 1:
        queue_free()
    if randi_range(0,1) == 1:
        _sprite_2d.flip_h = true
    var _walker: DirAccess = DirAccess.open(_textures_path)
    var _custom_character_textures : Array[String] = []
    _custom_character_textures.assign(_walker.get_files())
    _custom_character_textures.filter(func(file_name): return not "import" in file_name)
    var _texture_id : int = randi_range(0, _custom_character_textures.size() - 1)
    var _formated_path = "{}{}".format([_textures_path, _custom_character_textures[_texture_id]], "{}")
    _sprite_2d.texture = load(_formated_path)
    _current_state = State.IDLE
    var _male = "hombre" in _formated_path
    var _gender = "Male" if _male else "Female"
    _name = NameGenerator.get_random_name(_gender)
    return true


func make_space(body : Node2D) -> void:
    return

func enable_outline(color : Color = Color(0, 1, 0, 1)) -> void:
    # Create and assign a ShaderMaterial with the given outline shader
    if outline_shader:
        var mat = ShaderMaterial.new()
        mat.shader = outline_shader
        # Adjust parameters as needed
        mat.set_shader_parameter("outline_thickness", 0.5)
        mat.set_shader_parameter("outline_color", color)
        _sprite_2d.material = mat
    else:
        # No shader assigned
        _sprite_2d.material = null

func set_player_nearby(is_player_nearby : bool):
    _player_nearby = is_player_nearby

func disable_outline() -> void:
    _sprite_2d.material = null
