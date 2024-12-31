extends Control

# Tracks for testing
@export var background_music: AudioStream = preload("res://music/114bpmtest.mp3")
@export var battle_music: AudioStream = preload("res://music/171bpmtest.mp3")

# Nodes
var button: Button

# State: true = playing battle music, false = playing background music
var is_battle_music = false

func _ready():
	# Get the Button node
	button = $Button

	# Connect button pressed signal
	button.connect("pressed", Callable(self, "_on_button_pressed"))

	# Start playback with background music via MusicManager
	MusicManager.current_track = background_music
	MusicManager.current_bpm = 114
	MusicManager.start_track()
	button.text = "Play Battle Music"

# Handle button press
func _on_button_pressed():
	if is_battle_music:
		# Switch to background music
		MusicManager.set_next_track(background_music, 114)
		MusicManager.switch_to_next_track()
		button.text = "Play Battle Music"
		is_battle_music = false
	else:
		# Switch to battle music
		MusicManager.set_next_track(battle_music, 171)
		MusicManager.switch_to_next_track()
		button.text = "Play Background Music"
		is_battle_music = true
