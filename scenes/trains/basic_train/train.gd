extends Node2D

signal level_won

const _LEFT_WIDTH: int = 329
const _CENTER_WIDTH: int = 329
const Y: int = 95

@onready var _right: Node2D = $Right
@onready var _hud: CanvasLayer = %HUD
@onready var _fahrkartenkonrtolleurin = $Fahrkartenkonrtolleurin

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
    var train_length: int = _rng.randi_range(0, 3)
    for i in train_length:
        var center_scene: Node2D = center.instantiate()
        center_scene.position = Vector2(_center_x(i), Y)
        self.add_child(center_scene)
    _right.position.x = _right_x(train_length)
    _spawn_farhkarten_kontrolleurin()
    SignalDispatcher.sound_music.emit("train")

func _spawn_farhkarten_kontrolleurin():
    if randi() % 20 == 5:
        _fahrkartenkonrtolleurin.position.x = _right.position.x + 100
    else:
        get_tree().queue_delete(_fahrkartenkonrtolleurin)
        print("Schackeline will not hunt you today")


func _on_player_talk_enabled() -> void:
    _hud.show_interaction_button()


func _on_player_talk_disabled() -> void:
    _hud.hide_interaction_button()


func _on_player_hud_toggled(visible: bool) -> void:
    _hud.visible = visible
