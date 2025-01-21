extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    SignalDispatcher.sound_music.connect(_on_sound_music)

func play_sound_effect(sound) -> void:
    print("playing music")
    if sound:
        self.stream = sound
        self.play()
    else:
        print("Error: Could not load sound at path")


func _on_sound_music(music_name) -> void:
    print("signal received: " + music_name)
    match music_name:
        "background":
            var sound = preload("res://assets/sounds/music/backgroundmusic.mp3")
            play_sound_effect(sound)
        "main_menu":
            var sound = preload("res://assets/sounds/music/main-menu-music.mp3")
            play_sound_effect(sound)
        "train":
            var sound = preload("res://assets/sounds/music/d_d_Battle_music.mp3")
            play_sound_effect(sound)



