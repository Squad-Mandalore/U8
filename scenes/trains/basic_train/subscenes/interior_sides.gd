extends StaticBody2D

@onready var dirt_sprites: Array = [$Dirt, $Dirt2]

func _ready() -> void:
    for i in range(dirt_sprites.size()):
        dirt_sprites[i].visible = randi_range(0, [1, 3][i]) == 1
