extends Npc

const SPEED: float = 30.0
@export var LEFT_BOUNDARY: int = 77

var _is_interacting: bool = false
var _player_checked: bool = false

func _ready() -> void:
    _sprite.play("walk")

func _physics_process(delta: float) -> void:
    if _is_interacting:
        return  # Skip movement during interaction

    # Move left at a constant speed
    velocity = Vector2(-SPEED, 0)
    move_and_collide(velocity * delta)

    # Check if the Npc has reached the boundary
    if global_position.x <= LEFT_BOUNDARY:
        queue_free()  # Despawn the Npc

func _on_detect_characters_body_entered(body):
    if _is_interacting or body == self:
        return

    # First, see if this is an Npc or a subclass of Npc (e.g., WalkingNpc).
    var npc_body = body as Npc
    if npc_body:
        _is_interacting = true
        _sprite.play("idle")
        if is_obstacle_in_path(npc_body):
            npc_body.make_space(self as Node2D)
        while is_obstacle_in_path(npc_body):
            await get_tree().create_timer(2.0).timeout
        _continue_walking()
    # If not Npc, check if it's the player’s layer
    elif body.get_collision_layer() == 3 and not _player_checked:
        _is_interacting = true
        _sprite.play("idle")
        if not player_has_ticket(body):
            SourceOfTruth.balance_changed(-60)
            print("Player didn't have a ticket")
        else:
            print("Player had a ticket")
        _player_checked = true

        # Optional: If we also want to wait for the player to move:
        while is_obstacle_in_path(body):
            await get_tree().process_frame
        _continue_walking()


func _continue_walking():
    await get_tree().create_timer(2.0).timeout
    _is_interacting = false
    _sprite.play("walk")

func player_has_ticket(player) -> bool:
    # TODO: correctly implement source of truth
    return randi() % 3 == 1  # Placeholder

func is_obstacle_in_path(body) -> bool:
    var collision_shape = body.find_child("CollisionShape2D", true, false)
    if collision_shape:
        var body_rect = collision_shape.global_transform.origin
        if abs(body_rect.y - global_position.y) < 20:
            if body_rect.x < global_position.x:
                return (global_position.x - body_rect.x) < 70
    return false
