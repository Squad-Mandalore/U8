extends StaticBody2D

@onready var timer: Timer = $Timer
@onready var _fire_left: Node2D = $Fire
@onready var _fire_right: Node2D = $Fire2

func _ready() -> void:
    _fire_left.hide()
    _fire_right.hide()
    set_random_timer()

func set_random_timer() -> void:
    var wait_time = randf_range(30.0, 180.0)
    timer.wait_time = wait_time
    timer.start()    

func activate_fire() -> void:
    _fire_left.show()

func activate_fire2() -> void:
    _fire_right.show()

func extinguish_fire() -> void:
    _fire_left.hide()

func extinguish_fire2() -> void:
    _fire_right.hide()

func _on_timer_timeout() -> void:
    if randi() % 5 == 0:
        if randi() % 2 == 0:
            activate_fire()
        else:
            activate_fire2()
    set_random_timer()
