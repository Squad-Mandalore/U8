extends Control

var counter: int = 1

func increment():
    counter += 1
    %RoundDescriptorLabel.text = "Runde " + str(counter)

# DEBUG
func _on_panel_container_mouse_entered() -> void:
    SignalDispatcher.combat_exit.emit(get_parent().get_parent().get_parent().get_parent().get_parent())

