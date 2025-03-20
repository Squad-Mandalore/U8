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
@onready var navigation_region: NavigationRegion2D = $Node2D

const NPCS: Array[PackedScene] = [
    preload("res://characters/npcs/beggar/beggar_1.tscn"),
    preload("res://characters/npcs/berghain_guest/berghain_guest.tscn"),
    preload("res://characters/npcs/big_child/big_child.tscn"),
    preload("res://characters/npcs/sports_fans/eisbaeren/eisbaeren_1.tscn"),
    preload("res://characters/npcs/sports_fans/eisbaeren/eisbaeren_2.tscn"),
    preload("res://characters/npcs/sports_fans/eisbaeren/eisbaeren_3.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man1/man1.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man2/man2.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man3/man3.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man4/man4.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man5/man5.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/girl/girl.tscn"),
    preload("res://characters/npcs/pidgeon/pidgeon.tscn")
]

const STATION_NPC: PackedScene = preload("res://characters/npcs/station_exclusive/basic_npc/train_station_npc.tscn")

const SPECIAL_NPCS: Array[PackedScene] = [
    preload("res://characters/npcs/badman/badman.tscn"),
]

const NUMBER_NPCS: int = 20
const NUMBER_SPECIAL_NPCS: int = 1

signal train_enter

func _ready() -> void:
    SignalDispatcher.player_zero_health.connect(_on_player_zero_health)
    player.speed_multiplier = 0.0
    player.hide()
    animation_player.play("train_enter")
    SignalDispatcher.sound_music.emit("station")
    spawn_npcs()
    navigation_region.bake_navigation_polygon()
    

func spawn_npcs() -> void:
    var npc_spawn_points = []
    for i in range(NUMBER_NPCS):
        npc_spawn_points.append(navigation_node.random_point_in_polygon())
    spawn_objects_transform(NPCS, npc_spawn_points, navigation_node)
    npc_spawn_points.clear()
    for i in range(NUMBER_SPECIAL_NPCS):
        npc_spawn_points.append(navigation_node.random_point_in_polygon())
    spawn_objects(SPECIAL_NPCS, npc_spawn_points, navigation_node)

func spawn_objects(object_scenes: Array, spawn_points: Array, parent_node: Node) -> void:
    for spawn_point in spawn_points:
        var i = randi() % object_scenes.size()
        var instance = object_scenes[i].instantiate()
        instance.position = spawn_point
        instance.z_index = 0
        parent_node.add_child(instance)
        
func spawn_objects_transform(object_scenes: Array, spawn_points: Array, parent_node: Node) -> void:
    for spawn_point in spawn_points:
        var i = randi() % object_scenes.size()
        var instance = object_scenes[i].instantiate()

        if instance.has_method("_ready") and instance is WalkingNpc:
            var station_npc = STATION_NPC.instantiate()
            station_npc.position = spawn_point
            
            var sprite_instance = instance.get_node_or_null("AnimatedSprite2D")
            var sprite_station = station_npc.get_node_or_null("AnimatedSprite2D")

            if sprite_instance and sprite_station:
                if sprite_instance.sprite_frames:
                    sprite_station.sprite_frames = sprite_instance.sprite_frames
                sprite_station.offset = sprite_instance.offset
                sprite_station.animation = sprite_instance.animation
                sprite_station.flip_h = sprite_instance.flip_h

            if instance.has_meta("npc_name") and station_npc.has_meta("npc_name"):
                station_npc.set_meta("npc_name", instance.get_meta("npc_name"))

            instance.queue_free()
            parent_node.add_child(station_npc)
        else:
            instance.position = spawn_point
            instance.z_index = 0
            parent_node.add_child(instance)
            
        var nav_obstacle = NavigationObstacle2D.new()
        nav_obstacle.avoidance_enabled = true
        nav_obstacle.radius = 12
        instance.add_child(nav_obstacle)



func _on_player_zero_health() -> void:
    SignalDispatcher.level_lost.emit()

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
