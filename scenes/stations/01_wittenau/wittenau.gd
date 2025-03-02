extends Node2D

signal train_enter

@onready var animation_player = $AnimationPlayer
@onready var olaf = %OlafScholz
@export var combat_background: Texture2D
@export var combat_background_left: Texture2D
@export var combat_floor: Texture2D
var train_accessable = false

func _ready() -> void:
    SignalDispatcher.sound_music.emit("station")

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
        "olaf_step_aside":
            train_enter.emit()

