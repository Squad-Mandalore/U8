extends StaticBody2D
class_name SeatingArea

@onready var timer: Timer = $Timer
@onready var _fire_left: Node2D = $Fire
@onready var _fire_right: Node2D = $Fire2
var _activate_left: bool = false
var _activate_right: bool = false

func _ready() -> void:
    _fire_left.hide()
    _fire_right.hide()
    set_random_timer()

func set_random_timer() -> void:
    var wait_time = randf_range(5.0, 15.0)
    timer.wait_time = wait_time
    timer.start()    

func activate_fire() -> void:
    if randi_range(0,2) == 1:
        _activate_left = true
        set_random_timer()

func activate_fire2() -> void:
    if randi_range(0,2) == 1:
        _activate_right = true
        set_random_timer()

func extinguish_fire() -> void:
    _fire_left.hide()

func extinguish_fire2() -> void:
    _fire_right.hide()

func _on_timer_timeout() -> void:
    if _activate_left:
        _fire_left.show()
        _activate_left = false
    elif _activate_right:
        _fire_right.show()
        _activate_right = false
