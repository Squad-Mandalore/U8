extends Sprite2D
class_name SeatedNpc

enum State {IDLE, TALK}

var _current_state: State = State.IDLE
var _player_nearby: bool = false

var _name : String = "Random Dude"
const outline_shader = preload("res://characters/npcs/assets/npc.gdshader")
@export var _textures_path : String = "res://characters/npcs/seated/pointed_away/assets/"

func _ready():
    if randi_range(0,5) == 1:
        queue_free()
    if randi_range(0,1) == 1:
        self.flip_h = true
    var _walker: DirAccess = DirAccess.open(_textures_path)
    var _custom_character_textures : Array[String] = []
    _custom_character_textures.assign(_walker.get_files())
    _custom_character_textures.filter(func(file_name): return not "import" in file_name)
    var _texture_id : int = randi_range(0, _custom_character_textures.size() - 1)
    var _formated_path = "{}{}".format([_textures_path, _custom_character_textures[_texture_id]], "{}")
    self.texture = load(_formated_path)
    _current_state = State.IDLE
    var _male = "hombre" in _formated_path
    var _gender = "Male" if _male else "Female"
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
        self.material = mat
    else:
        # No shader assigned
        self.material = null

func set_player_nearby(is_player_nearby : bool):
    _player_nearby = is_player_nearby

func disable_outline() -> void:
    self.material = null
