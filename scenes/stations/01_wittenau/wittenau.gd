extends Node2D

signal train_enter

@onready var animation_player = $AnimationPlayer
@onready var olaf = %OlafScholz
@onready var animation_train = $Node2D/AnimationTrain
@onready var player = $Node2D/Berliner
@export var combat_background: Texture2D
@export var combat_background_left: Texture2D
@export var combat_floor: Texture2D
var train_accessable = false

func _ready() -> void:
    SignalDispatcher.sound_music.emit("station")
    animation_train.activated = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
    if train_accessable:
        animation_player.play("olaf_step_aside")
    else:
        animation_player.play("olaf_initial_battle")

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    match anim_name:
        "olaf_initial_battle":
            olaf.start_combat()
            train_accessable = true
        "train_leave":
            train_enter.emit()

func _on_animation_train_body_entered(_body: Node2D) -> void:
    animation_train.deactivate_doors()
    player.hide()
    player.speed_multiplier = 0.0
    animation_player.play("train_leave")
