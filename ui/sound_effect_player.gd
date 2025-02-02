extends AudioStreamPlayer

var hover_item_effect = preload("res://ui/inventory/assets/sounds/effects/hover-item.wav")
var open_inventory_effect = preload("res://ui/inventory/assets/sounds/effects/open-inventory.wav")
var exit_inventory = preload("res://ui/inventory/assets/sounds/effects/exit-inventory-menu.wav")
var pop_effect = preload("res://assets/sounds/effects/pop_effect.wav")
var villager_effect = preload("res://assets/sounds/effects/villager_effect.wav")
var exit_effect = preload("res://assets/sounds/effects/exit_effect.wav")

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
            play_sound_effect(hover_item_effect)
        "open_inventory":
            play_sound_effect(pop_effect)
        "exit_inventory":
            play_sound_effect(pop_effect)
        "pop":
            play_sound_effect(pop_effect)
        "exit":
            play_sound_effect(exit_effect)
        "villager":
            play_sound_effect(villager_effect)


