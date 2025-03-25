extends Node

var station_music = preload("res://assets/sounds/music/station_music.wav")
var combat_music = preload("res://assets/sounds/music/boss_music_1.wav")
var main_menu_music = preload("res://assets/sounds/music/main_menu_music.mp3")
var train_music = preload("res://scenes/trains/basic_train/assets/sounds/music/gof2.wav")
var last_emitted = ""

var current_music: AudioStreamPlayer = null
var dummy_player: AudioStreamPlayer = null
var fade_speed = 1.0
var target_volume = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    SignalDispatcher.sound_music.connect(_on_music_effect)
    current_music = AudioStreamPlayer.new()
    current_music.bus = "Musik"
    add_child(current_music)

    dummy_player = AudioStreamPlayer.new()
    dummy_player.bus = "Musik"
    add_child(dummy_player)

    current_music.connect("finished", _on_music_finished)
    current_music.volume_db = 0

func _process(delta):
    if dummy_player.playing:
        current_music.volume_db -= fade_speed * delta * 10
        dummy_player.volume_db += fade_speed * delta * 10

        if dummy_player.volume_db >= target_volume:
            current_music.volume_db = target_volume
            dummy_player.volume_db = -60
            current_music.stream = dummy_player.stream
            current_music.play(dummy_player.get_playback_position())
            dummy_player.stop()

func play_music(audio_stream: AudioStream, volume_db: float = 0):
    if current_music.stream == audio_stream and current_music.playing:
        return  # Already playing

    target_volume = volume_db

    if not current_music.playing:
        # Instant play if no music is running
        current_music.stream = audio_stream
        current_music.volume_db = volume_db
        current_music.play()
        return

    dummy_player.stream = audio_stream
    dummy_player.volume_db = -60  # Start silent
    dummy_player.play()

func _on_music_finished():
    if current_music:
        current_music.play()

func _on_music_effect(sound_name: String) -> void:
    if sound_name == "combat_exit":
        sound_name = last_emitted
    if sound_name != "combat":
        last_emitted = sound_name

    match sound_name:
        "station":
            play_music(station_music, 0)
        "train":
            play_music(train_music, -10)
        "combat":
            play_music(combat_music, -5)
        "main_menu":
            play_music(main_menu_music, -5)
