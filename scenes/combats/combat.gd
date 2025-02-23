extends Node3D

@onready var _background: Node3D = $Background
@export var player_texture: Texture2D
const aura_shader = preload("res://characters/assets/aura.gdshader")

var combat_background: Texture2D
var combat_background_left: Texture2D
var combat_floor: Texture2D

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

func _ready() -> void:
	# Texture updates must be in ready, because the background is set on ready and not before.
	set_back_wall_texture(combat_background)
	set_left_wall_texture(combat_background_left)
	set_floor_texture(combat_floor)
	%Berliner.material_overlay.set_shader_parameter("sprite_texture", player_texture)

# TODO: use these function to ulpdate the textures for the station
func set_back_wall_texture(texture: Texture2D):
	_background.set_back_wall_texture(texture)

func set_left_wall_texture(texture: Texture2D):
	_background.set_left_wall_texture(texture)

func set_floor_texture(texture: Texture2D):
	_background.set_floor_texture(texture)

func enable_aura(color: Color, damage_donor: String):
	if damage_donor == "Spieler":
		%Berliner.material_overlay.set_shader_parameter("aura_color", color)
	else:
		%Enemy.material_overlay.set_shader_parameter("aura_color", color)

func disable_aura(damage_donor: String) -> void:
	enable_aura(Color(0), damage_donor)
