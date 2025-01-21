extends ParallaxLayer

@export var speed = 340

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    self.motion_offset.x += speed * delta
