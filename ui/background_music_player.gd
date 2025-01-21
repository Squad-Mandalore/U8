extends AudioStreamPlayer

var background_music = preload("res://assets/sounds/music/backgroundmusic.wav")
var main_menu_music = preload("res://assets/sounds/music/main-menu-music.mp3")
var train_music = preload("res://assets/sounds/music/d_d_Battle_music.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("i am so ready aehm aehm")
    SignalDispatcher.sound_music.connect(_on_sound_music)

func play_sound_music(music) -> void:
    print("playing music")
    self.stop()
    self.stream = music
    self.play()


func _on_sound_music(music_name) -> void:
    print("signal received: " + music_name)
    match music_name:
        "background":
            play_sound_music(background_music)
        "main_menu":
            play_sound_music(main_menu_music)
        "train":
            play_sound_music(train_music)



