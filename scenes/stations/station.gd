extends Node2D
class_name Station

@onready var animation_train_collision = $Background/AnimationTrain/CollisionShape2D
@onready var player = $Node2D/Berliner
@onready var animation_player = $AnimationPlayer

signal train_enter

func _ready() -> void:
    animation_player.play("train_enter")

func change_station_label(title: String, second_title: String = ""):
    var tmp: String = title + "\n" + second_title
    %StationName.text = tmp

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    match anim_name:
        "train_enter":
            _on_animation_train_enter()
        "train_leave":
            _on_animation_train_leave()

func _on_animation_train_enter():
    animation_train_collision.disabled = false

func _on_animation_train_leave():
    train_enter.emit()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    animation_train_collision.disabled = true
    player.hide()
    player.speed = 0.0
    animation_player.play("train_leave")
