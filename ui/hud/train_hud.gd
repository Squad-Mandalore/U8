extends CanvasLayer

var talk_action_key: String

func _ready() -> void:
    %ButtonHud.set_key_icon("talk")
    %ButtonHud.hide()

func show_interaction_button() -> void:
    %ButtonHud.show()

func hide_interaction_button() -> void:
    %ButtonHud.hide()

func show_status_panel() -> void:
    %StatusPanel.show()

func hide_status_panel() -> void:
    %StatusPanel.hide()

func _on_button_hud_pressed() -> void:
    (get_parent() as Player).toggle_talking()
