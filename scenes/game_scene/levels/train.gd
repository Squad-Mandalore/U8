extends Node2D

signal level_won

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_area_2d_body_entered(body:Node2D) -> void:
    level_won.emit()


func _on_player_talk_enabled() -> void:
    $HUD.show_interaction_button()


func _on_player_talk_disabled() -> void:
    $HUD.hide_interaction_button()

func _on_player_hud_toggled(visible: bool) -> void:
    $HUD.visible = visible
