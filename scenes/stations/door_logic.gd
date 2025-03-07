extends StaticBody2D
class_name AnimatedWagons

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _door_colisions: StaticBody2D = $DoorColisions

enum DoorState { CLOSED, OPENING, OPEN, CLOSING }
var door_state = DoorState.CLOSED

func _ready() -> void:
    _animated_sprite_2d.play("idle")
    _animated_sprite_2d.pause()
    _animated_sprite_2d.frame = 0
    _animated_sprite_2d.animation_finished.connect(_on_animation_finished)
    _door_colisions.collision_layer = 1

func open_doors() -> void:
    if door_state != DoorState.CLOSED && door_state != DoorState.CLOSING:
        return
    door_state = DoorState.OPENING
    _animated_sprite_2d.play("open")

func close_doors() -> void:
    if door_state != DoorState.OPEN && door_state != DoorState.OPENING:
        return
    door_state = DoorState.CLOSING
    _animated_sprite_2d.play_backwards("open")
    _enable_collisions()

func _disable_collisions() -> void:
    _door_colisions.collision_layer = 0

func _enable_collisions() -> void:
    _door_colisions.collision_layer = 1

func _on_animation_finished() -> void:
    match door_state:
        DoorState.OPENING:
            door_state = DoorState.OPEN
            _disable_collisions()
        DoorState.CLOSING:
            door_state = DoorState.CLOSED
