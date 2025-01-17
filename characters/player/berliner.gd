class_name Player
extends CharacterBody2D

const SPEED: float = 102.0
var _slowdown_entities: Array[NPC] = []

@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var inventory: CanvasLayer = $Inventory

func _ready() -> void:
    inventory.hide()
    stats_changed.emit(stats, balance)

enum State {IDLE, WALK, TALK, SCOOT}
var _current_state: State = State.IDLE
var _scooting_enabled: bool = true  # Set to false to disable SHIFT toggling for scoot mode

signal talk_enabled()
signal talk_disabled()
signal hud_toggled(visible: bool)
signal stats_changed(stats: StatsSpecifier, balance: int)


@export var stats: StatsSpecifier
var balance: int

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK:
        # If talking, skip movement
        return

    if _current_state == State.SCOOT:
        _handle_scooting(delta)
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var speed = SPEED
    if _slowdown_entities.size() > 0:
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

func _input(event: InputEvent):
    if event.is_action_pressed("inventory"):
        var canvas_layer: CanvasLayer = ($Inventory as CanvasLayer)
        var toggle: bool = canvas_layer.visible

        hud_toggled.emit(toggle)
        canvas_layer.visible = !toggle

    # 1) If the player presses "talk" and at least one NPC is nearby,
    #    pick the best NPC according to facing & distance, talk to it only.
    if event.is_action_pressed("talk") and _slowdown_entities.size() > 0:
        var talkable := _get_best_npc()
        if talkable == null:
            return  # No valid NPC in front or something else

        print("Talking")
        if _current_state == State.TALK:
            talkable.stop_talking()
            _on_npc_stopped_talking(talkable)
        else:
            talkable.start_talking()
            _on_npc_started_talking(talkable)

func _on_slowdown_area_body_entered(body: Node2D):
    var npc: NPC = body
    _slowdown_entities.append(npc)
    npc.set_player_nearby(true)
    _update_talkable_npc()

func _on_slowdown_area_body_exited(body: Node2D):
    var npc: NPC = body
    npc.set_player_nearby(false)
    npc.disable_outline()
    _slowdown_entities.erase(npc)
    _update_talkable_npc()


func _on_npc_started_talking(npc: NPC):
    switch_state(State.TALK)
    print("You are now talking to %s." % npc._name)

func _on_npc_stopped_talking(npc: NPC):
    switch_state(State.IDLE)
    print("You are no longer talking to %s." % npc._name)

func _disable_scooting():
    _scooting_enabled = false
    print("Scooting disabled")

func _enable_scooting():
    _scooting_enabled = true
    print("Scooting enabled")

func damage(damage_taken: int):
    stats.health -= damage_taken
    stats_changed.emit(stats)

func _on_stats_changed(stats: StatsSpecifier, balance: int) -> void:
    inventory.update_stats(stats, balance)


func _get_best_npc() -> NPC:
    if _slowdown_entities.is_empty():
        return null

    var x_dir = -1.0 if _animated_sprite_2d.flip_h else 1.0
    var facing_dir = Vector2(x_dir, 0.0)

    #  Among all NPCs, pick those "in front" of the player
    #  Then pick the closest among them. If none in front, pick the closest overall.
    var best_npc: NPC = null
    var best_dist = INF
    var my_pos = global_position

    # We'll track if we found at least one in front
    var found_in_front = false

    for npc in _slowdown_entities:
        var diff = npc.global_position - my_pos
        var dot_val = facing_dir.dot(diff)
        var dist = diff.length()

        if dot_val > 0:
            # NPC is in front
            found_in_front = true
            if dist < best_dist:
                best_dist = dist
                best_npc = npc
        else:
            # NPC is behind or to the side
            # We'll only consider it if we have no in-front NPC at all
            if not found_in_front and dist < best_dist:
                best_dist = dist
                best_npc = npc

    return best_npc

func _update_talkable_npc() -> void:
    # Clear outline on all
    for ent in _slowdown_entities:
        ent.disable_outline()

    if _slowdown_entities.is_empty():
        talk_disabled.emit()
        return

    # Get the NPC we want to talk to
    var best = _get_best_npc()
    if best:
        best.enable_outline(Color(0, 1, 0, 1))
        talk_enabled.emit()
    else:
        talk_disabled.emit()

func toggle_talking():
    var bodies = $SlowdownArea.get_overlapping_bodies()
    if bodies.size() < 1:
        return
    if !_current_state == State.TALK:
        switch_state(State.TALK)
        (bodies[0] as NPC)._start_talking()
    else:
        switch_state(State.IDLE)
        (bodies[0] as NPC)._stop_talking()
