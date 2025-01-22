extends Station

@onready var animation_train_collision = $Background/AnimationTrain/CollisionShape2D
@onready var player = $Node2D/CharacterBody2D
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
    animation_player.play("train_enter")

func _on_animation_train_enter():
    animation_train_collision.disabled = false

func _on_animation_train_leave():
    train_enter.emit()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    animation_train_collision.disabled = true
    player.hide()
    player.speed = 0.0
    animation_player.play("train_leave")

