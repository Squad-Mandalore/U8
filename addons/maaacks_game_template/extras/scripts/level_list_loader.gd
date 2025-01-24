@tool
class_name LevelListLoader
extends SceneLister
## Extends [SceneLister] to manage level advancement through [GameStateExample].

signal level_load_started
signal level_loaded
signal levels_finished

## Container where the level instance will be added.
@export var level_container : Node

var current_level : Node

func _ready() -> void:
    SignalDispatcher.combat_enter.connect(_on_combat_enter)
    SignalDispatcher.combat_exit.connect(_on_combat_exit)

func get_level_file(level_id : int):
    if files.is_empty():
        push_error("levels list is empty")
        return
    if level_id >= files.size():
        push_error("level_id is out of bounds of the levels list")
    return files[level_id]

func _on_combat_enter():
    var combat_scene = preload("res://scenes/combats/combat.tscn")
    level_container.call_deferred("remove_child", current_level)
    var instance = combat_scene.instantiate()
    level_container.call_deferred("add_child", instance)

func _on_combat_exit(to_free: Node):
    to_free.queue_free()
    level_container.call_deferred("add_child", current_level)

func _attach_level(level_resource : Resource):
    assert(level_container != null, "level_container is null")
    var instance = level_resource.instantiate()
    level_container.call_deferred("add_child", instance)
    return instance

func load_level(level_id : int):
    if is_instance_valid(current_level):
        current_level.queue_free()
        await current_level.tree_exited
        current_level = null
    var level_file: StationSettings = get_level_file(level_id)
    if level_file == null:
        levels_finished.emit()
        return
    SceneLoader.load_scene(level_file.path, true)
    level_load_started.emit()
    await SceneLoader.scene_loaded
    current_level = _attach_level(SceneLoader.get_resource())
    level_loaded.emit()

func load_level_path(scene_path : String):
    if is_instance_valid(current_level):
        current_level.queue_free()
        await current_level.tree_exited
        current_level = null
    if scene_path == null:
        levels_finished.emit()
        return
    SceneLoader.load_scene(scene_path, true)
    level_load_started.emit()
    await SceneLoader.scene_loaded
    current_level = _attach_level(SceneLoader.get_resource())
    level_loaded.emit()
