extends CharacterBody2D

@export var speed: float = 102
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation_to_play: String = "RESET"

func _ready():
    animation_player.stop()
    animation_player.play(animation_to_play)

func _physics_process(_delta: float) -> void:
    var direction: Vector2 = Input.get_vector("left", "right", "up", "down")

    velocity = direction * speed

    if direction != Vector2.ZERO:
        animation_to_play = "walk"
    else:
        animation_to_play = "RESET"

    animation_player.play(animation_to_play)
    move_and_slide()
