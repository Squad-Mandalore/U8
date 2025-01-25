extends NPC
class_name Enemy

@export var attacks: Array[Attack]
@export var albedo_texture: AtlasTexture
@export var combat_animation: String = "battle_idle"
@export var stats: StatsSpecifier


func _ready() -> void:
    _current_state = State.IDLE
    if RANDOM_NAME:
        _name = NameGenerator.get_random_name(_gender)
    # Enemy needs duplicated attacks otherwise it could interfere with the players attacks
    for i in range(len(attacks)):
        attacks[i] = attacks[i].duplicate()
        attacks[i].calculate_damage(stats)

# TODO: Use functions below do start boss fight in the future
func start_talking() -> void:
    _current_state = State.TALK
    enable_outline(Color(0, 0, 1, 1))

func stop_talking() -> void:
    _current_state = State.IDLE
    enable_outline(Color(0, 1, 0, 1))

func start_combat():
    SignalDispatcher.combat_enter.emit(self)

func enable_outline(color : Color = Color(1, 0, 0, 1)) -> void:
    if outline_shader:
        var mat = ShaderMaterial.new()
        mat.shader = outline_shader
        mat.set_shader_parameter("outline_thickness", 0.5)
        mat.set_shader_parameter("outline_color", color)
        _sprite.material = mat
    else:
        _sprite.material = null
