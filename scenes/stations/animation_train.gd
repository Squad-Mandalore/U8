extends Area2D
class_name AnimatedTrain

@onready var _center: AnimatedWagons = $Center
@onready var _left: AnimatedWagons = $Left
@onready var _right: AnimatedWagons = $Right

var activated: bool = false

func activate_doors() -> void:
    activated = true
    _open_all_doors()

func deactivate_doors() -> void:
    activated = false
    _close_all_doors()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    if activated:
        _open_all_doors()

func _on_area_2d_body_exited(_body: Node2D) -> void:
    if activated:
        _close_all_doors()

func _open_all_doors() -> void:
    _center.open_doors()
    _left.open_doors()
    _right.open_doors()

func _close_all_doors() -> void:
    _center.close_doors()
    _left.close_doors()
    _right.close_doors()
