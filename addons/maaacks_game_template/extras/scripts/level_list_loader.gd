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

func _on_combat_enter(enemy: Enemy):
    var combat_scene = preload("res://scenes/combats/combat.tscn")
    var combat_enter_scene = preload("res://scenes/combats/subscenes/combat_enter.tscn")
    # Assumes no fight takes place in Wittenau since it does not inherit station
    # load textures of current level
    var combat_background: Texture2D = current_level.combat_background
    var combat_background_left: Texture2D = current_level.combat_background_left
    var combat_floor: Texture2D = current_level.combat_floor
    # combat_enter_scene
    var combat_enter_instance = combat_enter_scene.instantiate()
    level_container.get_parent().call_deferred("add_child", combat_enter_instance)
    combat_enter_instance.enemy = enemy
    await get_tree().create_timer(5).timeout
    level_container.get_parent().call_deferred("remove_child", combat_enter_instance)
    # pause the current_level
    level_container.call_deferred("remove_child", current_level)
    # setup combat scene
    var instance = combat_scene.instantiate()
    instance.enemy = enemy
    instance.combat_background = combat_background
    instance.combat_background_left = combat_background_left
    instance.combat_floor = combat_floor
    # instantiate combat scene
    level_container.call_deferred("add_child", instance)
    instance.disable_aura("Spieler")
    instance.disable_aura("Other")

func _on_combat_exit(to_free: Node):
    var combat_exit_won_scene = preload("res://scenes/combats/subscenes/combat_exit_won.tscn")

    level_container.get_parent().call_deferred("add_child", combat_exit_won_scene)
    await get_tree().create_timer(5).timeout
    level_container.get_parent().call_deferred("remove_child", combat_exit_won_scene)
    
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
    current_level = _attach_level(level_file.station)
    level_loaded.emit()

func load_scene(scene : Resource):
    if is_instance_valid(current_level):
        current_level.queue_free()
        await current_level.tree_exited
        current_level = null
    if scene == null:
        levels_finished.emit()
        return
    current_level = _attach_level(scene)
    level_loaded.emit()
