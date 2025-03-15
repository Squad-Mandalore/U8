extends Node2D

signal train_enter
signal level_lost

@onready var animation_player = $AnimationPlayer
@onready var olaf = %OlafScholz
@onready var animation_train = $Node2D/AnimationTrain
@onready var player = $Node2D/Berliner
@onready var initial_battle_animation: Animation = animation_player.get_animation(&"olaf_initial_battle")
@onready var step_aside_animation: Animation = animation_player.get_animation(&"olaf_step_aside")
@export var combat_background: Texture2D
@export var combat_background_left: Texture2D
@export var combat_floor: Texture2D
var train_accessable = false
var is_olaf_aside = false

func _ready() -> void:
    SignalDispatcher.player_zero_health.connect(_on_player_zero_health)
    SignalDispatcher.sound_music.emit("station")
    animation_train.activated = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
    if not train_accessable:
        var closest_door: Node = _get_closest_door()
        initial_battle_animation.track_set_key_value(0, 0, closest_door.global_position + Vector2(0, -45.0))
        initial_battle_animation.track_set_key_value(0, 1, closest_door.global_position)
        initial_battle_animation.track_set_key_value(5, 0, closest_door.global_position)
        initial_battle_animation.track_set_key_value(5, 1, closest_door.global_position + Vector2(39.0, 60.0))
        step_aside_animation.track_set_key_value(0, 0, closest_door.global_position + Vector2(18.0, 0))
        $Node2D/Berliner/AnimatedSprite2D.flip_h = player.global_position.x > closest_door.global_position.x
        animation_player.play("olaf_initial_battle")
    elif not is_olaf_aside:
        animation_player.play("olaf_step_aside")
        is_olaf_aside = true

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


func _get_closest_door() -> Node:
    var doors: Array[Node] = animation_train.find_children("Marker2D*", &"Marker2D", false, true)
    var player_pos: Vector2 = player.global_position
    var min_dist: float = INF
    var min_door: Node = doors[0]

    for door: Node in doors:
        var dist: float = player_pos.distance_to(door.global_position)
        if dist < min_dist:
            min_dist = dist
            min_door = door

    return min_door

func _on_player_zero_health() -> void:
    level_lost.emit()
