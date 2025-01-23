class_name Player
extends CharacterBody2D

@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var inventory: CanvasLayer = $Inventory
@onready var _slowdown_area: Area2D = $SlowdownArea
# var stats: StatsSpecifier = StatsSpecifier.new()
# var base_stats: StatsSpecifier

enum State {IDLE, WALK, TALK, SCOOT, DANCE}
var _current_state: State = State.IDLE
var _scooting_enabled: bool = true  # Set to false to disable SHIFT toggling for scoot mode

const SPEED: float = 102.0
var speed_multiplier: float = 1.0
var _talkable_npc: NPC = null:
    set(value):
        if value:
            speed_multiplier = 0.5
        else:
            speed_multiplier = 1.0
        _talkable_npc = value

signal talk_enabled()
signal talk_disabled()
signal hud_toggled(visible: bool)

func _ready() -> void:
    inventory.hide()
    SignalDispatcher.reload_ui.emit()

# func _process(delta):
#     pass
    # print("Player Position: " + str(self.global_position))
    # print("Camera Position: " + str(%InventoryCamera.global_position))

func _physics_process(delta: float) -> void:
    if _current_state == State.TALK or _current_state == State.DANCE:
        # If talking, skip movement
        return

    if _current_state == State.SCOOT:
        _handle_scooting(delta)
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var speed = SPEED * speed_multiplier

    if direction.x < 0 and not _animated_sprite_2d.flip_h:
        _animated_sprite_2d.flip_h = true
        if _talkable_npc:
            _update_talkable_npc(_slowdown_area.get_overlapping_bodies())
    elif direction.x > 0 and _animated_sprite_2d.flip_h:
        _animated_sprite_2d.flip_h = false
        if _talkable_npc:
            _update_talkable_npc(_slowdown_area.get_overlapping_bodies())

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
    # The maximum length at top scoot speed is speed*2.
    # At top speed, we want 8 FPS; at zero speed, 0 FPS.
    var max_speed = float(speed * 2)
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
            State.DANCE:
                _animated_sprite_2d.play("dance")

func _unhandled_input(event: InputEvent):
    if event.is_action_pressed("dance"):
        if _current_state == State.DANCE:
            switch_state(State.IDLE)
        else:
            switch_state(State.DANCE)
            
    if not _scooting_enabled:
        return

    if event.is_action_pressed("scoot"):
        if _current_state == State.SCOOT:
            switch_state(State.IDLE)
        else:
            switch_state(State.SCOOT)
            _animated_sprite_2d.play("scooting_horizontal")


func _input(event: InputEvent):
    if event.is_action_pressed("ui_cancel"):
        toggle_inventory(false)
        SignalDispatcher.sound_effect.emit("exit")

    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            SignalDispatcher.toggle_item_hud.emit(null)
    if event.is_action_pressed("inventory"):
        toggle_inventory()
        SignalDispatcher.sound_effect.emit("pop")



func _on_slowdown_area_body_entered(body: Node2D):
    var npc: NPC = body
    npc.set_player_nearby(true)
    if _current_state != State.TALK:
        _update_talkable_npc(_slowdown_area.get_overlapping_bodies())

func _on_slowdown_area_body_exited(body: Node2D):
    var npc: NPC = body
    npc.set_player_nearby(false)
    npc.disable_outline()
    if _current_state != State.TALK:
        _update_talkable_npc(_slowdown_area.get_overlapping_bodies())

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

func _get_best_npc(npcs: Array[Node2D]) -> NPC:
    if npcs.is_empty():
        return null

    var x_dir = -1.0 if _animated_sprite_2d.flip_h else 1.0
    var facing_dir = Vector2(x_dir, 0.0)

    #  Among all NPCs, pick those "in front" of the player
    #  Then pick the closest among them. If none in front, pick the closest overall.
    var best_npc: NPC = null
    var best_dist = INF
    var my_pos: Vector2 = global_position

    # We'll track if we found at least one in front
    var found_in_front = false

    for npc: NPC in npcs:
        var diff: Vector2 = npc.global_position - my_pos
        var dot_val: float = facing_dir.dot(diff)
        var dist: float = diff.length()

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

func _update_talkable_npc(npcs: Array[Node2D]) -> void:
    # Clear outline on all
    for ent: NPC in npcs:
        ent.disable_outline()


    # Get the NPC we want to talk to
    _talkable_npc = _get_best_npc(npcs)
    if !_talkable_npc:
        talk_disabled.emit()
        return

    _talkable_npc.enable_outline(Color(0, 1, 0, 1))
    talk_enabled.emit()

func toggle_talking():
    if !_talkable_npc:
        return

    if !_current_state == State.TALK:
        switch_state(State.TALK)
        _talkable_npc.start_talking()
        SignalDispatcher.sound_effect.emit("villager")
        _on_npc_started_talking(_talkable_npc)
    else:
        switch_state(State.IDLE)
        _talkable_npc.stop_talking()
        _on_npc_stopped_talking(_talkable_npc)

func toggle_inventory(set = null):
    var toggle = set
    if set == null:
        toggle = !inventory.visible

    hud_toggled.emit(!toggle)
    inventory.visible = toggle
