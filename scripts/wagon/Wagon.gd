extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Example in a Wagon script
func on_entered_wagon():
	var wagon_track = preload("res://music/114bpmtest.mp3")
	var wagon_bpm = 114
	MusicManager.set_next_track(wagon_track, wagon_bpm)
