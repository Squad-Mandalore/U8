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

func get_level_file(level_id : int):
    if files.is_empty():
        push_error("levels list is empty")
        return
    if level_id >= files.size():
        push_error("level_id is out of bounds of the levels list")
        level_id = files.size() - 1
    return files[level_id]

func _attach_level(level_resource : Resource, level_file: StationSettings = null):
    assert(level_container != null, "level_container is null")
    var instance = level_resource.instantiate()
    if instance is Station:
        instance.change_station_label(level_file.name, level_file.subtitle)
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
    current_level = _attach_level(SceneLoader.get_resource(), level_file)
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
