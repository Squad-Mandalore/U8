extends Node

# Properties for current and next track
@export var current_track: AudioStream = null
@export var current_bpm: int = 120
@export var next_track: AudioStream = null
@export var next_bpm: int = 120

# Nodes for playback
var current_player: AudioStreamPlayer
var next_player: AudioStreamPlayer
var loop_timer: Timer

# Shared variables for transition (used by special_transition)
var _quarter_note = 0.0
var _one_beat = 0.0      # Full note = 4 quarter notes
var _bar_duration = 0.0  # 3 quarter notes (3/4 measure)
var _loop_duration = 0.0
var _loop_count = 0
var _num_loops_before_overlay = 0
var _num_loops_during_overlay = 0
var _total_loops = 0
var _next_bar_start = 0.0

func _ready():
	# Initialize AudioStreamPlayers and Timer
	current_player = AudioStreamPlayer.new()
	next_player = AudioStreamPlayer.new()
	loop_timer = Timer.new()
	loop_timer.one_shot = false  # Repeated loop points if needed

	# Add nodes to the scene tree
	add_child(current_player)
	add_child(next_player)
	add_child(loop_timer)

	# Connect Timer signal using Godot 4 syntax
	loop_timer.timeout.connect(_handle_loop_point)

	# Start playback of the current track from the beginning
	if current_track:
		start_track()

# Start playing the current track from the beginning
func start_track():
	current_player.stream = current_track
	current_player.volume_db = 0.0
	current_player.play(0.0)  # Explicitly from position 0.0

# Transition to the next track
func switch_to_next_track():
	# 3/4-based "special transition" if condition is met
	if next_track and abs(next_bpm - (current_bpm * 0.75 * 2)) == 0:
		special_transition()
	else:
		standard_transition()

# Update the next track (called by wagons or button input)
func set_next_track(track: AudioStream, bpm: int):
	next_track = track
	next_bpm = bpm

# -------------------------------------------------
#  STANDARD TRANSITION (CROSSFADE WITH ONE-BEAT DELAY)
# -------------------------------------------------
func standard_transition():
	stop_loop_timer()

	# Define durations based on the current BPM:
	_quarter_note = 60.0 / current_bpm
	_one_beat = _quarter_note * 4.0  # 1 full note = 4 quarter notes

	# Next track (fade in from -40 dB -> 0 dB)
	next_player.stop()
	next_player.stream = next_track
	next_player.volume_db = -40.0
	next_player.play(0.0)

	# We'll fade in next_player immediately, then wait _one_beat, then fade out current_player.
	var fade_duration = 2.0  # seconds, tweak to taste
	var tween = get_tree().create_tween()

	# 1) Fade in next_player from -40 dB to 0 dB
	tween.tween_property(
		next_player,
		"volume_db",
		0.0,
		fade_duration
	).from(-40.0)

	# 2) Wait exactly one beat (4 quarter notes)
	tween.tween_interval(_one_beat)

	# 3) Fade out current_player from (assume 0 dB) to -40 dB
	tween.tween_property(
		current_player,
		"volume_db",
		-40.0,
		fade_duration
	).from(current_player.volume_db)

	# 4) After fade-out completes, finalize the transition
	tween.tween_callback(Callable(self, "_finalize_standard_transition"))

func _finalize_standard_transition():
	# Stop old track
	current_player.stop()

	# Swap players so next_player becomes the new "current_player"
	var temp_player = current_player
	current_player = next_player
	next_player = temp_player

	# Update track references
	current_track = next_track
	current_bpm = next_bpm
	next_track = null
	next_bpm = 0

	# Ensure new current_player is at 0 dB
	current_player.volume_db = 0.0

# -------------------------------------------------
#  SPECIAL TRANSITION (3/4 LOOPING + CROSSFADE)
# -------------------------------------------------
func special_transition():
	# quarter_note = 60 / BPM
	_quarter_note = 60.0 / current_bpm
	_one_beat     = _quarter_note * 4.0    # 4 quarter notes
	_bar_duration = _quarter_note * 3.0    # 3 quarter notes for 3/4
	_loop_duration = _bar_duration

	var num_loops_before_overlay = 3
	var num_loops_during_overlay = 3
	var total_loops = num_loops_before_overlay + num_loops_during_overlay

	_loop_count = 0
	_num_loops_before_overlay = num_loops_before_overlay
	_num_loops_during_overlay = num_loops_during_overlay
	_total_loops = total_loops

	# 1) Get a more accurate playback position by adding the mixing offset
	var mix_offset = AudioServer.get_time_since_last_mix()
	var real_position = current_player.get_playback_position() + mix_offset

	# 2) Snap to the start of the next bar (3 quarter notes)
	var next_bar_start = real_position
	if fmod(real_position, _bar_duration) > 0.0:
		next_bar_start = (floor(real_position / _bar_duration) + 1) * _bar_duration

	_next_bar_start = next_bar_start

	# 3) Calculate how long until (next_bar_start + _loop_duration)
	var time_to_loop_point = (next_bar_start + _loop_duration) - real_position

	# 4) Subtract a small epsilon so we fire fractionally earlier
	var epsilon = 0.01
	time_to_loop_point = max(0.0, time_to_loop_point - epsilon)

	# 5) Restart current track from real_position
	current_player.stop()
	current_player.play(real_position)

	# 6) Use a Timer to begin looping after that time
	var initial_timer = Timer.new()
	initial_timer.wait_time = time_to_loop_point
	initial_timer.one_shot = true
	add_child(initial_timer)
	initial_timer.timeout.connect(_start_looping)
	initial_timer.start()

func _start_looping():
	# Kick off the repeated 3-quarter-note loop
	loop_timer.wait_time = _loop_duration
	loop_timer.one_shot = false
	loop_timer.start()

# Called each time the 3-quarter-note segment ends
func _handle_loop_point():
	_loop_count += 1

	if _loop_count <= _total_loops:
		# Re-trigger the bar (3 quarter notes)
		current_player.stop()
		current_player.play(_next_bar_start)

		# When it's time for the overlay, fade in track 2,
		# then one full beat later, fade out track 1
		if _loop_count == _num_loops_before_overlay + 1:
			next_player.stop()
			next_player.stream = next_track
			next_player.volume_db = -40.0
			next_player.play(0.0)

			var fade_duration = 3.0
			var tween = get_tree().create_tween()

			# 1) Fade in next_player right away
			tween.tween_property(
				next_player,
				"volume_db",
				0.0,
				fade_duration
			).from(-40.0)

			# 2) Wait one full beat (4 quarter notes) before fading out current_player
			tween.tween_interval(_one_beat)

			# 3) Fade out current_player from 0 dB -> -40 dB
			tween.tween_property(
				current_player,
				"volume_db",
				-40.0,
				fade_duration
			).from(current_player.volume_db)

	else:
		# Finalize the transition after the total loops
		stop_loop_timer()
		current_player.stop()

		# Swap players so next_player becomes the new "current_player"
		var temp_player = current_player
		current_player = next_player
		next_player = temp_player

		current_track = next_track
		current_bpm = next_bpm
		next_track = null
		next_bpm = 0

		# Reset volume to 0.0 dB for the new current track
		current_player.volume_db = 0.0

# Stop and clean up the loop timer
func stop_loop_timer():
	if not loop_timer.is_stopped():
		loop_timer.stop()
