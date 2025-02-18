extends StaticBody2D
class_name AnimatedWagons

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _door_colisions: StaticBody2D = $DoorColisions
var _doors_open = true

signal doors_fully_opened
signal doors_start_closing

func _ready() -> void:
    _animated_sprite_2d.play("idle")
    _animated_sprite_2d.pause()
    _animated_sprite_2d.frame = 0
    _animated_sprite_2d.connect("animation_finished", _on_animation_finished)

func open_doors() -> void:
    _doors_open = false
    _animated_sprite_2d.play("open")

func close_doors() -> void:
    _animated_sprite_2d.play_backwards("open")
    _enable_colisions()
    doors_start_closing.emit()

func _disable_colisions() -> void:
    _doors_open = true
    _door_colisions.collision_layer = 0 
    doors_fully_opened.emit()

func _enable_colisions() -> void:
    _doors_open = false
    _door_colisions.collision_layer = 1

func _on_animation_finished() -> void:
    if _animated_sprite_2d.animation == "open" and not _doors_open:
        _disable_colisions()
