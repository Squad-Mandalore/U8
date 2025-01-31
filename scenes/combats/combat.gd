extends Node3D

@onready var _background: Node3D = $Background
@export var player_texture: Texture2D
const aura_shader = preload("res://characters/assets/aura.gdshader")

var enemy: Enemy:
    set(value):
        enemy = value
        update_enemy()
        %CombatHud.set_enemy(enemy)

func update_enemy():
    %Enemy.sprite_frames = enemy._sprite.sprite_frames
    %Enemy.animation = enemy.combat_animation
    %Enemy.play()

# TODO: use these function to ulpdate the textures for the station
func set_back_wall_texture(texture: Texture2D):
    _background.set_back_wall_texture(texture)

func set_left_wall_texture(texture: Texture2D):
    _background.set_left_wall_texture(texture)

func set_floor_texture(texture: Texture2D):
    _background.set_floor_texture(texture)

func enable_aura(color: Color, player: bool):
    # Create and assign a ShaderMaterial with the given outline shader
    var mat = ShaderMaterial.new()
    mat.shader = aura_shader
    # Adjust parameters as needed
    mat.set_shader_parameter("aura_color", color)
    if player:
        mat.set_shader_parameter("sprite_texture", player_texture)
        %Berliner.material_overlay = mat
    else:
        mat.set_shader_parameter("sprite_texture", enemy.texture)
        %Enemy.material_overlay = mat

func disable_aura(player: bool) -> void:
    if player:
        %Enemy.material_overlay = null
    else:
        %Enemy.material_overlay = null
