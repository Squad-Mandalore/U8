class_name Player
extends CharacterBody2D

const SPEED: float = 102.0
var _slowdown_entities: int = 0:
    set(value):
        _slowdown_entities = max(value, 0)

@onready var _animated_sprite_2d = $AnimatedSprite2D

enum State {IDLE, WALK, TALK}
var _current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK:
        # If talking, skip movement
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var speed = SPEED
    if _slowdown_entities > 0:
        speed = SPEED / 2

    if direction.x < 0:
        _animated_sprite_2d.flip_h = true
    elif direction.x > 0:
        _animated_sprite_2d.flip_h = false

    if direction != Vector2.ZERO:
        velocity = direction * speed
        switch_state(State.WALK)
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.y = move_toward(velocity.y, 0, speed)
        switch_state(State.IDLE)

    move_and_collide(velocity * delta)

func switch_state(new_state: State):
    if new_state != _current_state:
        _current_state = new_state
        match _current_state:
            State.TALK:
                _animated_sprite_2d.play("talk")
            State.WALK:
                _animated_sprite_2d.play("walk")
            State.IDLE:
                _animated_sprite_2d.play("idle")


func _on_slowdown_area_body_entered(body: Node):
    if body is NPC:
        # If we meet an NPC, slow down the player
        _slowdown_entities += 1

        # Connect signals so we know when the NPC starts/stops talking
        var npc: NPC = body
        if not npc.is_connected("npc_started_talking", _on_npc_started_talking):
            npc.connect("npc_started_talking", _on_npc_started_talking)

        if not npc.is_connected("npc_stopped_talking", _on_npc_stopped_talking):
            npc.connect("npc_stopped_talking", _on_npc_stopped_talking)

func _on_slowdown_area_body_exited(body: Node):
    if body is NPC:
        # If the NPC leaves, reduce slowdown count
        _slowdown_entities -= 1

        # Disconnect signals
        var npc: NPC = body
        if npc.is_connected("npc_started_talking", _on_npc_started_talking):
            npc.disconnect("npc_started_talking", _on_npc_started_talking)

        if npc.is_connected("npc_stopped_talking", _on_npc_stopped_talking):
            npc.disconnect("npc_stopped_talking", _on_npc_stopped_talking)

func _on_npc_started_talking(npc: NPC):
    # If NPC started talking, the player also enters TALK mode
    switch_state(State.TALK)
    print("NPC started talking to you")

func _on_npc_stopped_talking(npc: NPC):
    # If NPC stopped talking, the player reverts to IDLE (or WALK if moving)
    switch_state(State.IDLE)
    print("NPC stopped talking to you")
