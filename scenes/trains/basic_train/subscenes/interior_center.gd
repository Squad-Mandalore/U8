extends StaticBody2D

@onready var dirt_sprites: Array = [$Dirt, $Dirt2, $Dirt3]
@onready var broken_window: Sprite2D = $BrokenWindow

func _ready() -> void:
    for i in range(dirt_sprites.size()):
        dirt_sprites[i].visible = randi_range(0, [1, 3, 10][i]) == 1

    broken_window.visible = randi_range(0, 5) == 1
