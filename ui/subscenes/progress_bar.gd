extends VBoxContainer

@export var texture_under: Texture
@export var texture_progress: Texture
@export var texture_over: Texture
@export var nine_patch_margins: Vector4 = Vector4(10, 10, 10, 10)  # left, top, right, bottom
@export var margin_bottom: int = 0
@export var font_size: int = 0

func _ready():
    # Set textures and nine-patch margins dynamically
    var nine_patch_rect = (%ProgressBar as TextureProgressBar)
    set_margin_bottom(margin_bottom)
    set_font_size(font_size)
    if nine_patch_rect:
        nine_patch_rect.texture_under = texture_under
        nine_patch_rect.texture_progress = texture_progress
        nine_patch_rect.stretch_margin_left = nine_patch_margins.x
        nine_patch_rect.stretch_margin_top = nine_patch_margins.y
        nine_patch_rect.stretch_margin_right = nine_patch_margins.z
        nine_patch_rect.stretch_margin_bottom = nine_patch_margins.w

func set_stat_name(name: String):
    %StatNameLabel.text = name

func set_stat(cur_value: int, max_value: int) -> void:
    cur_value = min(cur_value, max_value)
    set_max_value(max_value)
    set_stat_number("%d/%d" % [cur_value, max_value])
    set_cur_value(cur_value)

func set_stat_number(number: String):
    %StatNumberLabel.text = number

func set_max_value(max_value: int):
    %ProgressBar.max_value = max_value

func set_cur_value(cur_value: int):
    %ProgressBar.value = cur_value

func set_margin_bottom(margin_bottom: int):
    %MarginBottom.add_theme_constant_override("margin_bottom", margin_bottom)

func set_font_size(font_size: int):
    %StatNameLabel.add_theme_font_size_override("font_size", font_size)
    %StatNumberLabel.add_theme_font_size_override("font_size", font_size)
    # %StatNumberLabel.add_theme_font_override("font_size", font_size)
