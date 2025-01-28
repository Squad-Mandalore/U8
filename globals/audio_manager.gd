extends Node

var statio_music = preload("res://assets/sounds/music/station_music.wav")
var combat_music = preload("res://assets/sounds/music/boss_music_1.wav")
var train_music = preload("res://scenes/trains/basic_train/assets/sounds/music/gof2.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
   SignalDispatcher.sound_music.connect(_on_music_effect)

var current_music: AudioStreamPlayer = null

func play_music(audio_stream: AudioStream, volume_db: float = 0):
    if current_music == null:
        # Create a new AudioStreamPlayer if it doesn't exist
        current_music = AudioStreamPlayer.new()
        current_music.connect("finished", Callable(self, "_on_music_finished"))
        add_child(current_music)

    # Check if the requested music is already playing
    if current_music.stream == audio_stream and current_music.playing:
        return  # Do nothing if it's already playing

    # Set the new stream and play it
    current_music.stream = audio_stream
    current_music.bus = "Music"
    current_music.volume_db = volume_db
    current_music.play()

func _on_music_finished():
    # Restart the track when it finishes to simulate looping
    if current_music:
        current_music.play()

func _on_music_effect(sound_name: String) -> void:
    match sound_name:
        "station":
            play_music(statio_music)
        "train":
            play_music(train_music)
        "combat":
            play_music(combat_music)
