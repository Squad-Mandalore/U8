extends Node2D
class_name Station

@onready var navigation_node = $Node2D
@onready var player = $Node2D/Berliner
@onready var animation_player = $AnimationPlayer
@export var combat_background: Texture2D
@onready var combat_background_left: Texture2D = $Background/BackgroundWall.texture
@export var combat_floor: Texture2D
@onready var animation_train: AnimatedTrain = $Node2D/AnimationTrain
@onready var upper_collision: CollisionShape2D = $Background/CollisionShape2D
@export var automata_spawns: Array[Vector2] = []
@export var human_shop_spawns: Array[Vector2] = []

const AUTOMATAS: Array[PackedScene] = [
    preload("res://characters/automatas/drink/drink_vending_machine.tscn"),
    preload("res://characters/automatas/snack/snack_vending_machine.tscn"),
]
const HUMAN_SHOPS: Array[PackedScene] = [
    preload("res://characters/automatas/speati/spaeti.tscn"),
    preload("res://characters/automatas/doener-house/doener_house.tscn"),
    preload("res://characters/automatas/clothes/clothing_container.tscn"),
]
const NPCS: Array[PackedScene] = [
    preload("res://characters/npcs/badman/badman.tscn"),
    preload("res://characters/npcs/beggar/beggar_1.tscn"),
    preload("res://characters/npcs/berghain_guest/berghain_guest.tscn"),
    preload("res://characters/npcs/big_child/big_child.tscn"),
]

const NUMBER_NPCS: int = 20

signal train_enter
signal level_lost

func _ready() -> void:
    SignalDispatcher.player_zero_health.connect(_on_player_zero_health)
    player.speed_multiplier = 0.0
    player.hide()
    animation_player.play("train_enter")
    SignalDispatcher.sound_music.emit("station")
    spawn_npcs()
    spawn_automatas()
    if Utils.chance(50):
        spawn_human_shops()

func spawn_npcs() -> void:
    var npc_spawn_points = []
    for i in range(NUMBER_NPCS):
        npc_spawn_points.append(navigation_node.random_point_in_polygon())
    spawn_objects(NPCS, npc_spawn_points, navigation_node)

func spawn_automatas() -> void:
    spawn_objects(AUTOMATAS, automata_spawns, navigation_node)

func spawn_human_shops() -> void:
    spawn_objects(HUMAN_SHOPS, human_shop_spawns, navigation_node)

func spawn_objects(object_scenes: Array, spawn_points: Array, parent_node: Node) -> void:
    for spawn_point in spawn_points:
        var i = randi() % object_scenes.size()
        var instance = object_scenes[i].instantiate()
        instance.position = spawn_point
        instance.z_index = 0
        parent_node.add_child(instance)

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

func _on_animation_train_leave():
    train_enter.emit()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    animation_train.deactivate_doors()
    player.hide()
    player.speed_multiplier = 0.0
    animation_player.play("train_leave")
