extends Area2D

@export var target_scene: PackedScene

func _input(event: InputEvent) -> void:
    if !event.is_action_pressed("ui_accept"):
        return

    if get_overlapping_bodies().size() < 1:
        return

    if !target_scene:
        push_error("no scene in this door")
        return

    var err = get_tree().change_scene_to_packed(target_scene)

    if err != OK:
        push_error("door not in scene")

