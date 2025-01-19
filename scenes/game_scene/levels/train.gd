extends Node2D

signal level_won

const _LEFT_WIDTH: int = 329
const _CENTER_WIDTH: int = 329
const Y: int = 95

@onready var _right: Node2D = $Right
@onready var _hud: CanvasLayer = %HUD

var _rng = RandomNumberGenerator.new()
var center: PackedScene  = preload("res://models/train/center.tscn")

func _on_area_2d_body_entered(_body: Node2D) -> void:
    level_won.emit()

func _right_x(train_length: int) -> float:
    assert(train_length >= 0)
    return _CENTER_WIDTH * train_length + _LEFT_WIDTH

func _center_x(train_length: int) -> float:
    assert(train_length >= 0)
    return _CENTER_WIDTH * train_length + _LEFT_WIDTH

func _enter_tree() -> void:
    var train_length: int = _rng.randi_range(0, 3)
    for i in train_length:
        var center_scene: Node2D = center.instantiate()
        center_scene.position = Vector2(_center_x(i), Y)
        self.add_child(center_scene)

    _right.position.x = _right_x(train_length)


func _on_player_talk_enabled() -> void:
    _hud.show_interaction_button()


func _on_player_talk_disabled() -> void:
    _hud.hide_interaction_button()


func _on_player_hud_toggled(visible: bool) -> void:
    _hud.visible = visible
