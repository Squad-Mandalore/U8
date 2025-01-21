extends Node2D
class_name Station

signal train_enter


func _on_area_2d_body_entered(_body: Node2D) -> void:
    train_enter.emit()

func change_station_label(title: String, second_title: String = ""):
    var tmp: String = title + "\n" + second_title
    %StationName.text = tmp

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    match anim_name:
        "train_enter":
            _on_animation_train_enter()
        "train_leave":
            _on_animation_train_leave()

func _on_animation_train_enter():
    pass

func _on_animation_train_leave():
    pass
