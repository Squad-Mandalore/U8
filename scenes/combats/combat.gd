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
    %Enemy.material_overlay.set_shader_parameter("sprite_texture", enemy.texture)
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

func enable_aura(color: Color, damage_donor: String):
    if damage_donor == "Spieler":
        var mat = %Berliner.material_overlay
        mat.set_shader_parameter("aura_color", color)
        mat.set_shader_parameter("sprite_texture", player_texture)
    else:
        var mat = %Enemy.material_overlay
        mat.set_shader_parameter("aura_color", color)
        mat.set_shader_parameter("sprite_texture", enemy.texture)

func disable_aura(damage_donor: String) -> void:
    if damage_donor == "Spieler":
        %Enemy.material_overlay = null
    else:
        %Enemy.material_overlay = null
