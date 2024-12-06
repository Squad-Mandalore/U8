extends CharacterBody2D


@export var speed: float = 300.0
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _physics_process(_delta: float) -> void:
    # handle_scale()
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))

    update_animation_parameters(direction)
    velocity = direction * speed

    move_and_slide()

    pick_state()

func update_animation_parameters(movement: Vector2) -> void:
    if(movement != Vector2.ZERO):
        animation_tree.set("parameters/Walk/blend_position", movement)
        animation_tree.set("parameters/Idle/blend_position", movement)

func pick_state() -> void:
    if(velocity != Vector2.ZERO):
        state_machine.travel("Walk")
    else:
        state_machine.travel("Idle")

func handle_scale() -> void:
    var min_scale = 6.0
    var max_scale = 50.0
    var far_distance = 200.0
    var near_distance = 350.0

    var distance: float = (position.y - far_distance) / near_distance

    print_debug(distance)

    scale.x = lerp(min_scale, max_scale, distance)
    scale.y = lerp(min_scale, max_scale, distance)
