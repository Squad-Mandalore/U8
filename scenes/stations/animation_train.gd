extends Area2D
class_name AnimatedTrain

@onready var _center: AnimatedWagons = $Center
@onready var _left: AnimatedWagons = $Left
@onready var _right: AnimatedWagons = $Right

var activated: bool = false
var doors_open: bool = false
var first_time: bool = true 
signal change_collisions(deactivate)

func activate_doors() -> void:
    if not activated:
        activated = true
        first_time = true
        _open_all_doors()

func deactivate_doors() -> void:
    activated = false
    _close_all_doors()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    if activated:
        _open_all_doors()

func _on_area_2d_body_exited(_body: Node2D) -> void:
    if first_time:
        first_time = false
        return
    
    if activated:
        _close_all_doors()

func _open_all_doors() -> void:
    doors_open = true
    _center.open_doors()
    _left.open_doors()
    _right.open_doors()

func _close_all_doors() -> void:
    doors_open = false
    _center.close_doors()
    _left.close_doors()
    _right.close_doors()

func _on_wagon_doors_fully_opened() -> void:
    doors_open = true
    change_collisions.emit(true) 

func _on_wagon_doors_start_closing() -> void:
    doors_open = false
    change_collisions.emit(false)
