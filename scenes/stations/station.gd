extends Node2D
class_name Station

@onready var animation_train_collision = $Node2D/AnimationTrain/CollisionShape2D
@onready var player = $Node2D/Berliner
@onready var animation_player = $AnimationPlayer
@export var combat_background: Texture2D
@onready var combat_background_left: Texture2D = $Background/BackgroundWall.texture
@export var combat_floor: Texture2D
@onready var animation_train: AnimatedTrain = $Node2D/AnimationTrain
@onready var upper_collision: CollisionShape2D = $Background/CollisionShape2D

signal train_enter
signal level_lost

func _ready() -> void:
    animation_train.change_collisions.connect(_on_collisions_changed)
    SignalDispatcher.player_zero_health.connect(_on_player_zero_health)
    player.speed_multiplier = 0.0
    player.hide()
    animation_player.play("train_enter")
    SignalDispatcher.sound_music.emit("station")

func _on_player_zero_health() -> void:
    level_lost.emit()

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    match anim_name:
        "train_enter":
            _on_animation_train_enter()
        "train_leave":
            _on_animation_train_leave()

func _on_animation_train_enter():
    animation_train.activate_doors()
    player.speed_multiplier = 1.0
    player.show()
    animation_train_collision.disabled = false

func _on_animation_train_leave():
    train_enter.emit()
    
func _on_collisions_changed(deactivate: bool) -> void:
    if upper_collision.disabled != deactivate:
        call_deferred("_disable_collisions", deactivate)

func _disable_collisions(deactivate: bool) -> void:
    if not is_inside_tree():
        await ready
    upper_collision.set_deferred("disabled", deactivate)
    
func _on_area_2d_body_entered(_body: Node2D) -> void:
    animation_train.deactivate_doors()
    animation_train_collision.call_deferred("set_disabled", true)
    player.hide()
    player.speed_multiplier = 0.0
    animation_player.play("train_leave")
