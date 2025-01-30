extends Node3D

@onready var _background: Node3D = $Background

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
