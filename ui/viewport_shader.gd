extends SubViewportContainer

var _paused : bool = false
var _accum_time: float = 0.0

func _ready():
    SignalDispatcher.reload_ui.connect(_update_drug_level)
    _update_drug_level()

func _process(delta):
    _accum_time = fmod(_accum_time + delta, 999999.0)
    var mat := material as ShaderMaterial
    if mat:
        mat.set_shader_parameter("offset_time", _accum_time)

func _update_drug_level():
    var drug_level = SourceOfTruth.stats.drug_level as float
    _set_wave_intensity(drug_level)

func _set_wave_intensity(value: float):
    value = clamp(value, 0.0, 3.0)
    var mat := material as ShaderMaterial
    if mat:
        mat.set_shader_parameter("wave_intensity", value)
