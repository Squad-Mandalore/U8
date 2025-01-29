class_name Player
extends CharacterBody2D

@onready var _animated_sprite_2d = $AnimatedSprite2D
@onready var _slowdown_area: Area2D = $SlowdownArea
@onready var _inventory: CanvasLayer = $Inventory
@onready var _hud: CanvasLayer = $HUD
@onready var _shop_hud: CanvasLayer = $Shop
@onready var _dialogue_box: CanvasLayer = $DialogueBox
var huds: Array[CanvasLayer]
# var stats: StatsSpecifier = StatsSpecifier.new()
# var base_stats: StatsSpecifier

enum State {IDLE, WALK, TALK, SCOOT, DANCE}
var _current_state: State = State.IDLE
var _scooting_enabled: bool = true  # Set to false to disable SHIFT toggling for scoot mode

const SPEED: float = 102.0
var speed_multiplier: float = 1.0
var _interactable_npc: PhysicsBody2D = null:
    set(value):
        if value:
            speed_multiplier = 0.5
        else:
            speed_multiplier = 1.0
        _interactable_npc = value

func _ready() -> void:
    huds = [_inventory, _hud, _shop_hud, _dialogue_box]
    set_active_hud(_hud)
    SourceOfTruth.set_damage_for_all_attacks()
    SourceOfTruth.balance_changed(10)
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
    elif direction.x > 0 and _animated_sprite_2d.flip_h:
        _animated_sprite_2d.flip_h = false

    if _interactable_npc:
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
        if _current_state == State.SCOOT:
            _animated_sprite_2d.speed_scale = 1.0
            speed_multiplier = 1.0
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
            State.SCOOT:
                speed_multiplier = 2.0
                _animated_sprite_2d.play("scooting_horizontal")


func _unhandled_input(event: InputEvent):
    if event.is_action_pressed("dance"):
        if _current_state == State.DANCE:
            switch_state(State.IDLE)
        else:
            switch_state(State.DANCE)

    if event.is_action_pressed("ui_cancel"):
        if _inventory.visible or _shop_hud.visible:
            set_active_hud(_hud)
            SignalDispatcher.sound_effect.emit("exit")
            get_viewport().set_input_as_handled()

    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and _inventory.inventory_info_panel.visible:
        SignalDispatcher.toggle_item_hud.emit(null)
        SignalDispatcher.sound_effect.emit("exit")

    if event.is_action_pressed("inventory"):
        set_active_hud(_hud if _inventory.visible else _inventory)
        if _inventory.visible:
            SignalDispatcher.sound_effect.emit("pop")
        else:
            SignalDispatcher.sound_effect.emit("exit")

    if not _scooting_enabled:
        return

    if event.is_action_pressed("scoot"):
        if _current_state == State.SCOOT:
            switch_state(State.IDLE)
        else:
            switch_state(State.SCOOT)

func _on_slowdown_area_body_entered(body: Node2D):
    var npc: PhysicsBody2D = body
    if npc is Npc:
        npc.set_player_nearby(true)
    if _current_state != State.TALK:
        _update_talkable_npc(_slowdown_area.get_overlapping_bodies())

func _on_slowdown_area_body_exited(body: Node2D):
    var npc: PhysicsBody2D = body
    if npc is Npc:
        npc.set_player_nearby(false)
        npc.disable_outline()
    if _current_state != State.TALK:
        _update_talkable_npc(_slowdown_area.get_overlapping_bodies())

func _start_talking(npc: Npc):
    switch_state(State.TALK)
    SignalDispatcher.sound_effect.emit("villager")
    _hud.hide_status_panel()
    _dialogue_box.show()
    _dialogue_box._on_node_2d_conversation_started(npc)
    print("You are now talking to %s." % npc._name)

func _stop_talking(npc: Npc):
    switch_state(State.IDLE)
    _dialogue_box.hide()
    _hud.show_status_panel()
    print("You are no longer talking to %s." % npc._name)

func _disable_scooting():
    _scooting_enabled = false
    print("Scooting disabled")

func _enable_scooting():
    _scooting_enabled = true
    print("Scooting enabled")

func _get_best_npc(npcs: Array[Node2D]) -> PhysicsBody2D:
    if npcs.is_empty():
        return null

    var x_dir = -1.0 if _animated_sprite_2d.flip_h else 1.0
    var facing_dir = Vector2(x_dir, 0.0)

    #  Among all NPCs, pick those "in front" of the player
    #  Then pick the closest among them. If none in front, pick the closest overall.
    var best_npc: PhysicsBody2D = null
    var best_dist = INF
    var my_pos: Vector2 = global_position

    # We'll track if we found at least one in front
    var found_in_front = false

    for npc: PhysicsBody2D in npcs:
        var diff: Vector2 = npc.global_position - my_pos
        var dot_val: float = facing_dir.dot(diff)
        var dist: float = diff.length()

        if dot_val > 0:
            # Npc is in front
            found_in_front = true
            if dist < best_dist:
                best_dist = dist
                best_npc = npc
        else:
            # Npc is behind or to the side
            # We'll only consider it if we have no in-front Npc at all
            if not found_in_front and dist < best_dist:
                best_dist = dist
                best_npc = npc

    return best_npc

func _update_talkable_npc(npcs: Array[Node2D]) -> void:
    # Clear outline on all
    for ent: PhysicsBody2D in npcs:
        ent.disable_outline()

    # Get the Npc we want to talk to
    _interactable_npc = _get_best_npc(npcs)
    if !_interactable_npc:
        _hud.hide_interaction_button()
        return

    _interactable_npc.enable_outline(Color(0, 1, 0, 1))
    _hud.show_interaction_button()

func toggle_interaction():
    if !_interactable_npc:
        return

    if _interactable_npc is Enemy:
        _interactable_npc.start_combat()
    elif _interactable_npc is ShopNpc or _interactable_npc is Automata:
        if _current_state != State.TALK:
            _interactable_npc.open_shop(_shop_hud)
            _start_shopping()
        else:
            _interactable_npc.close_shop()
            _stop_shopping()
    else:
        if _current_state != State.TALK:
            _interactable_npc.start_talking()
            _start_talking(_interactable_npc)
        else:
            _interactable_npc.stop_talking()
            _stop_talking(_interactable_npc)

func set_active_hud(active_hud: CanvasLayer = null):
    for hud in huds:
        hud.visible = (hud == active_hud)

func _on_dialogue_box_send_message(message):
    $EidolonHandler.post_message(message)

func _on_eidolon_handler_get_process_id(process_id):
    var message = "Process ID: %s" % process_id
    _dialogue_box.add_message("SYSTEM", message)

func _on_eidolon_handler_new_message():
    _dialogue_box.add_message("AGENT")

func _on_eidolon_handler_get_message(message):
    _dialogue_box.update_last_message(message)

func _on_eidolon_handler_finish_message():
    _dialogue_box.waiting = false

func _start_shopping():
    speed_multiplier = 0.0
    set_active_hud(_shop_hud)
    switch_state(State.TALK)

func _stop_shopping():
    speed_multiplier = 1.0
    set_active_hud(_hud)
    switch_state(State.IDLE)
