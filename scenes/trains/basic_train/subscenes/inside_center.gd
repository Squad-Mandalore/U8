extends StaticBody2D

@export var npc_scene: PackedScene = preload("res://characters/npcs/politician/politician_1.tscn")
@onready var _spawn_area = $SpawnArea

const GENERIC_ENEMYS: Array[PackedScene] = [
    preload("res://characters/npcs/beggar/beggar_enemy.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/girl/girl_enemy.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man1/man_1_enemy.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man2/man_2_enemy.tscn"),
    preload("res://characters/npcs/walking-decoration-dudes/man3/man_3_enemy.tscn"),
]

func get_random_spawn_position():
    var rects = []
    var total_area = 0

    # Collect all rectangles and calculate total area
    for child in _spawn_area.get_children():
        if child is CollisionShape2D and child.shape is RectangleShape2D:
            var child_rect_size = child.shape.size
            var area = child_rect_size.x * child_rect_size.y  # Area of the rectangle
            total_area += area
            rects.append({"node": child, "size": child_rect_size, "area": area})

    # if rects.is_empty():
    #     return _spawn_area.global_position  # Default if no shapes exist

    # Select a rectangle weighted by its area
    var random_area_pick = randf() * total_area
    var accumulated_area = 0

    var selected_rect = null
    for rect in rects:
        accumulated_area += rect["area"]
        if random_area_pick <= accumulated_area:
            selected_rect = rect
            break

    # Get a random position inside the chosen rectangle
    var rect_size = selected_rect["size"]
    var shape_origin = selected_rect["node"].global_position
    var random_x = randf_range(-rect_size.x / 2, rect_size.x / 2)
    var random_y = randf_range(-rect_size.y / 2, rect_size.y / 2)

    return shape_origin + Vector2(random_x, random_y)

func spawn_npc():
    var spawn_position = get_random_spawn_position()
    var index = randi() % GENERIC_ENEMYS.size()
    var npc = GENERIC_ENEMYS[index].instantiate()
    npc.position = spawn_position
    return npc
