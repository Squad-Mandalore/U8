extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    SignalDispatcher.sound_effect.connect(_on_sound_effect)

func play_sound_effect(sound) -> void:
    if sound:
        self.stream = sound
        self.play()
    else:
        print("Error: Could not load sound at path")


func _on_sound_effect(sound_name: String) -> void:
    match sound_name:
        "hover_item":
            var sound = preload("res://ui/inventory/assets/sounds/effects/hover-item.wav")
            play_sound_effect(sound)
        "open_inventory":
            var sound = preload("res://ui/inventory/assets/sounds/effects/open-inventory.wav")
            play_sound_effect(sound)
        "exit_inventory":
            var sound = preload("res://ui/inventory/assets/sounds/effects/exit-inventory-menu.wav")
            play_sound_effect(sound)


