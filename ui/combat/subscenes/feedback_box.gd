extends Control

@onready var rich_text_label = $PanelContainer/MarginContainer/FeedbackLabel
@onready var animation_player = $PanelContainer/MarginContainer/AnimationPlayer

# Our queue to store messages
var message_queue: Array = []
var busy: bool = false

# Call this function to add a new message
func add_message(message: String) -> void:
    message_queue.append(message)
    # If not already processing a message, start the queue
    if not busy:
        process_queue()

# Processes the messages one by one
func process_queue() -> void:
    busy = true
    while message_queue.size() > 0:
        var current_message = message_queue.pop_front()
        rich_text_label.text = current_message
        animation_player.play("typewriter")
        await animation_player.animation_finished
    busy = false
