class_name Player
extends CharacterBody2D

const SPEED: float = 102.0
var _slowdown_entities: int = 0:
    set(value):
        _slowdown_entities = max(value, 0)

@onready var _animated_sprite_2d = $AnimatedSprite2D

func _ready() -> void:
    SignalDispatcher.stats_changed.connect(_on_stats_changed)
    $Inventory.hide()
    var hawaiihemd = load("res://classes/item/hawaiihemd.tres")
    var hemd = load("res://classes/item/hemd.tres")
    var regenmantel = load("res://classes/item/regenmantel.tres")
    $Inventory/HBoxContainer/MarginContainer/InventoryHud.add_item(hawaiihemd)
    $Inventory/HBoxContainer/MarginContainer/InventoryHud.add_item(hemd)
    $Inventory/HBoxContainer/MarginContainer/InventoryHud.add_item(regenmantel)
    SignalDispatcher.stats_changed.emit(stats, balance)

enum State {IDLE, WALK, TALK, SCOOT}
var _current_state: State = State.IDLE
var _scooting_enabled: bool = true  # Set to false to disable SHIFT toggling for scoot mode

signal talk_enabled()
signal talk_disabled()
signal hud_toggled(visible: bool)


@export var stats: StatsSpecifier
var balance: int

func _process(delta):
    pass
    # print("Player Position: " + str(self.global_position))
    # print("Camera Position: " + str(%InventoryCamera.global_position))
    # %InventoryCamera.position = self.global_position

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

func _input(event: InputEvent):
    if event.is_action_pressed("inventory"):
        toggle_inventory()

func _on_slowdown_area_body_entered(_body: Node2D):
    # If we meet an NPC, slow down the player
    _slowdown_entities += 1

    talk_enabled.emit()

func _on_slowdown_area_body_exited(_body: Node2D):
    # If the NPC leaves, reduce slowdown count
    _slowdown_entities -= 1

    talk_disabled.emit()

func _disable_scooting():
    _scooting_enabled = false
    print("Scooting disabled")

func _enable_scooting():
    _scooting_enabled = true
    print("Scooting enabled")

func damage(damage_taken: int):
    stats.health -= damage_taken
    SignalDispatcher.stats_changed.emit(stats, balance)

func _on_stats_changed(stats: StatsSpecifier, balance: int) -> void:
    ($Inventory as CanvasLayer).update_inventory_stats(stats, balance)

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

func toggle_inventory():
    var inventory: CanvasLayer = ($Inventory as CanvasLayer)
    var toggle: bool = inventory.visible

    hud_toggled.emit(toggle)
    inventory.visible = !toggle
