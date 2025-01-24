extends Node2D
class_name Station

@onready var animation_train_collision = $Background/AnimationTrain/CollisionShape2D
@onready var player = $Node2D/Berliner
@onready var animation_player = $AnimationPlayer

signal train_enter
signal level_lost

func _ready() -> void:
    var result = SignalDispatcher.player_zero_health.connect(_on_player_zero_health)
    player.speed_multiplier = 0.0
    player.hide()
    animation_player.play("train_enter")

func _on_player_zero_health() -> void:
    print("hui")
    level_lost.emit()
    
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    match anim_name:
        "train_enter":
            _on_animation_train_enter()
        "train_leave":
            _on_animation_train_leave()

func _on_animation_train_enter():
    player.speed_multiplier = 1.0
    player.show()
    animation_train_collision.disabled = false

func _on_animation_train_leave():
    train_enter.emit()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    animation_train_collision.call_deferred("set_disabled", true)
    player.hide()
    player.speed_multiplier = 0.0
    animation_player.play("train_leave")
