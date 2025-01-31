extends Node3D

@onready var _back_wall: Sprite3D = $BackWall
@onready var _left_wall: Sprite3D = $LeftWall
@onready var _floor: Sprite3D = $Floor

func set_back_wall_texture(texture: Texture2D):
    _back_wall.texture = texture

func set_left_wall_texture(texture: Texture2D):
    _left_wall.texture = texture

func set_floor_texture(texture: Texture2D):
    _floor.texture = texture
