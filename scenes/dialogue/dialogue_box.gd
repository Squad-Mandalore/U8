extends CanvasLayer

@export var message_container_scene: PackedScene
@onready var enemy_animated_sprite_2d: AnimatedSprite2D = $EnemyAnimatedSprite2D
@onready var chat_history = %ChatHistory
@onready var message_input = %MessageInput

var waiting = false
var last_message = null

signal send_message(message)

func _update_sprite(character:Npc):
    if character._sprite:
        enemy_animated_sprite_2d.sprite_frames = character._sprite.sprite_frames
        enemy_animated_sprite_2d.animation = character._sprite.animation
        if enemy_animated_sprite_2d.sprite_frames.get_animation_names().has("idle"):
            enemy_animated_sprite_2d.play("idle")
        else:
            printerr("Only idle animation allowed!")

func add_message(sender, text=""):
    var container = message_container_scene.instantiate()
    container.set_side(sender)
    container.add_new_text(text)
    chat_history.add_child(container)
    last_message = text

func update_last_message(text="", replace=false):
    if replace: last_message = text
    else: last_message += text

func validate_message(message):
    if not (
        ensure_message_contents(message)
    ):
        return false
    return true

func ensure_message_contents(message):
    for i in range(len(message)):
        if (
            message[i] != ' '
            and message[i] != '\n'
            and message[i] != '\t'
        ):
            return true
    return false

func clear_contents():
    var vbox_container = chat_history
    if vbox_container:
        for child in vbox_container.get_children():
            vbox_container.remove_child(child)
            child.queue_free()
    else:
        printerr("VBoxContainer not found!")

func _on_node_2d_conversation_started(character: Npc) -> void:
    _update_sprite(character)


func _on_message_input_text_submitted(new_text: String) -> void:
    if not waiting:
        var message = message_input.text
        if validate_message(message):
            message_input.clear()
            add_message(false, message)
            waiting = true
            send_message.emit(message)
