extends Control

@onready var rich_text_label = %FeedbackLabel
@onready var animation_player = $AnimationPlayer
@onready var message_array_label = %MessageArrayLabel

var messages: Array = []
var current_index: int = 0  # Used for processing new messages.
var view_index: int = 0     # Used for user navigation.
var busy: bool = false

func add_message(message: String) -> void:
    messages.append(message)
    update_message_array_label()
    if not busy:
        process_queue()

func process_queue() -> void:
    busy = true
    while current_index < messages.size():
        # Always update the view to follow the new messages.
        view_index = current_index
        update_message_array_label()
        var current_message = messages[current_index]
        rich_text_label.text = current_message
        animation_player.play("typewriter")
        await animation_player.animation_finished
        current_index += 1
        if current_index == messages.size():
            SignalDispatcher.attack_swapper_toggle.emit(true)
    busy = false

func update_message_array_label():
    message_array_label.text = str(view_index + 1) + " / " + str(messages.size())

func _on_swap_button_left_pressed() -> void:
    if busy:
        return
    if view_index > 0:
        view_index -= 1
        rich_text_label.text = messages[view_index]
        update_message_array_label()

func _on_swap_button_right_pressed() -> void:
    if busy:
        return
    if view_index < messages.size() - 1:
        view_index += 1
        rich_text_label.text = messages[view_index]
        update_message_array_label()
