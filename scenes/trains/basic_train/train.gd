extends Node2D

signal level_won
signal level_lost

const _LEFT_WIDTH: int = 329
const _CENTER_WIDTH: int = 329
const Y: int = 95

@onready var _right: Node2D = $Right
@onready var _ticket_inspector = $TicketInspector
@export var combat_background: Texture2D
@export var combat_background_left: Texture2D
@export var combat_floor: Texture2D
@onready var animation_player = $AnimationPlayer

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
        self.add_child(center_scene.get_node("InsideCenter").spawn_npc())
    _right.position.x = _right_x(train_length)
    _spawn_ticket_inspector()
    SignalDispatcher.sound_music.emit("train")
    if GameState.get_current_station() == 0:
        animation_player.play("olaf_entrance")
    else:
        $Politiker.queue_free()


func _spawn_ticket_inspector():
    if Utils.chance(100.0):
        _ticket_inspector.position.x = _right.position.x + 100
    else:
        get_tree().queue_delete(_ticket_inspector)

func _on_player_zero_health() -> void:
    level_lost.emit()
