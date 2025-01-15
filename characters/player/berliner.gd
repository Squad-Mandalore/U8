class_name Player
extends CharacterBody2D

const SPEED: float = 102.0
var _slowdown_entities: int = 0:
    set(value):
        _slowdown_entities = max(value, 0)

@onready var _animated_sprite_2d = $AnimatedSprite2D

enum State {IDLE, WALK, TALK, SCOOT}
var _current_state: State = State.IDLE
var _scooting_enabled: bool = true  # Set to false to disable SHIFT toggling for scoot mode

@export var stats: Attributes

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK:
        # If talking, skip movement
        return
        
    if _current_state == State.SCOOT:
        _handle_scooting(delta)
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

func _handle_scooting(delta: float) -> void:
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction.x < 0:
        _animated_sprite_2d.flip_h = true
    elif direction.x > 0:
        _animated_sprite_2d.flip_h = false

    var speed = SPEED * 2

    if direction != Vector2.ZERO:
        velocity = direction * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.y = move_toward(velocity.y, 0, speed)

    move_and_collide(velocity * delta)

    # -- Decide which scooting animation to play based on movement direction --
    var vx = velocity.x
    var vy = velocity.y

    if vx == 0 and vy == 0:
        # Not moving: stop playing to keep the last frame
        _animated_sprite_2d.pause()
    else:
        # If moving predominantly up or down, pick the vertical animation, otherwise horizontal.
        if abs(vy) > abs(vx):
            if vy < 0:
                _animated_sprite_2d.play("scooting_upwards")
            else:
                _animated_sprite_2d.play("scooting_downwards")
        else:
            _animated_sprite_2d.play("scooting_horizontal")

        # Make sure the sprite is actively animating if it was previously stopped
        _animated_sprite_2d.play()

    # -- Adjust animation speed based on how fast we’re moving --
    # The maximum length at top scoot speed is SPEED*2.
    # At top speed, we want 8 FPS; at zero speed, 0 FPS.
    var max_speed = float(SPEED * 2)
    var current_speed = velocity.length()
    # Normalize (0.0 to 1.0)
    var speed_ratio = current_speed / max_speed
    # Scale up to 8 fps
    var desired_fps = speed_ratio * 8.0
    _animated_sprite_2d.speed_scale = desired_fps


func switch_state(new_state: State):
    if new_state != _current_state:
        # If we're leaving SCOOT mode, reset animation speeds
        if _current_state == State.SCOOT and new_state != State.SCOOT:
            _animated_sprite_2d.speed_scale = 1.0
        _current_state = new_state
        match _current_state:
            State.TALK:
                _animated_sprite_2d.play("talk")
            State.WALK:
                _animated_sprite_2d.play("walk")
            State.IDLE:
                _animated_sprite_2d.play("idle")
                
func _unhandled_input(event: InputEvent):
    if not _scooting_enabled:
        return

    if event.is_action_pressed("scoot"):
        if _current_state == State.SCOOT:
            switch_state(State.IDLE)
        else:
            switch_state(State.SCOOT)
            _animated_sprite_2d.play("scooting_horizontal")

func _on_slowdown_area_body_entered(body: Node2D):
    # If we meet an NPC, slow down the player
    _slowdown_entities += 1

    # Connect signals so we know when the NPC starts/stops talking
    var npc: NPC = body
    if not npc.is_connected("npc_started_talking", _on_npc_started_talking):
        npc.connect("npc_started_talking", _on_npc_started_talking)

    if not npc.is_connected("npc_stopped_talking", _on_npc_stopped_talking):
        npc.connect("npc_stopped_talking", _on_npc_stopped_talking)

func _on_slowdown_area_body_exited(body: Node2D):
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
    
func _disable_scooting():
    _scooting_enabled = false
    print("Scooting disabled")
    
func _enable_scooting():
    _scooting_enabled = true
    print("Scooting enabled")
