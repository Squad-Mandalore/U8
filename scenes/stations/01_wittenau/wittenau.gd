extends Node2D

signal train_enter


func _ready() -> void:
    SignalDispatcher.sound_music.emit("station")

func _on_area_2d_body_entered(_body: Node2D) -> void:
    train_enter.emit()
