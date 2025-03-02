extends CanvasLayer

func _ready() -> void:
    SignalDispatcher.map_exited.connect(queue_free)
