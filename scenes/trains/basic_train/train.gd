extends Node2D

signal level_won
signal level_lost

const _LEFT_WIDTH: int = 329
const _CENTER_WIDTH: int = 329
const Y: int = 95

@onready var _right: Node2D = $Right

var _rng = RandomNumberGenerator.new()
var center: PackedScene  = preload("res://scenes/trains/basic_train/subscenes/center.tscn")

func _on_area_2d_body_entered(_body: Node2D) -> void:
    level_won.emit()

func _right_x(train_length: int) -> float:
    assert(train_length >= 0)
    return _CENTER_WIDTH * train_length + _LEFT_WIDTH

func _center_x(train_length: int) -> float:
    assert(train_length >= 0)
    return _CENTER_WIDTH * train_length + _LEFT_WIDTH

func _ready() -> void:
    SignalDispatcher.player_zero_health.connect(_on_player_zero_health)
    var train_length: int = _rng.randi_range(0, 3)
    for i in train_length:
        var center_scene: Node2D = center.instantiate()
        center_scene.position = Vector2(_center_x(i), Y)
        self.add_child(center_scene)
    _right.position.x = _right_x(train_length)
    SignalDispatcher.sound_music.emit("train")
    
func _on_player_zero_health() -> void:
    level_lost.emit()
