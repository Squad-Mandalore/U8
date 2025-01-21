extends Node2D
class_name Station

signal train_enter


func _ready() -> void:
    SignalDispatcher.sound_music.emit("background")

func _on_area_2d_body_entered(_body: Node2D) -> void:
    train_enter.emit()

func change_station_label(title: String, second_title: String = ""):
    var tmp: String = title + "\n" + second_title
    %StationName.text = tmp
