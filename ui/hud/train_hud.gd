extends CanvasLayer

var talk_action_key: String

func _ready() -> void:
    talk_action_key = InputMap.action_get_events("talk")[0].as_text()[0]
    (%ButtonHud/InteractionKeyMarginBox/InteractionKeyLabel as Label).text = talk_action_key
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
