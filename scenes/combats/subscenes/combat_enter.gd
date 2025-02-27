extends CanvasLayer

@onready var enemy_animations = $ColorRect/Panel/Enemy
@onready var player_label = $ColorRect/Panel/Player_Label
@onready var enemy_label = $ColorRect/Panel/Enemy_Label
var enemy: Enemy

func _ready() -> void:
    update_enemy(enemy)

func update_enemy(enemy: Enemy) -> void:
    enemy_label.text = enemy._name
    # TODO - player Name generisch
    player_label.text = "Berliner"
    enemy_animations.sprite_frames = enemy._sprite.sprite_frames
    enemy_animations.animation = "battle_intro"
    enemy_animations.play()
