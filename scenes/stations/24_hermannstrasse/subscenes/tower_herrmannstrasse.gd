extends Tower
@export var tower_textures : Array[Texture2D]
@onready var _sprite_2d = $Sprite2D


func _ready():
    _sprite_2d.texture = tower_textures[randi_range(0, tower_textures.size() - 1)]
