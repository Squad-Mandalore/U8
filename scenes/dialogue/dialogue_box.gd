extends CanvasLayer

@export var message_container_scene: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var waiting = false
var last_message = null

signal send_message(message)

func _update_sprite(character:Npc):
    if character._sprite:
        animated_sprite_2d.sprite_frames = character._sprite.sprite_frames
        animated_sprite_2d.animation = character._sprite.animation
        if animated_sprite_2d.sprite_frames.get_animation_names().has("idle"):
            animated_sprite_2d.play("idle")
        else:
            printerr("Only idle animation allowed!")

func add_message(sender, text=""):
    var container = message_container_scene.instantiate()
    var name = Label.new()
    var message = Label.new()
    name.text = sender + " -"
    message.autowrap_mode = 3
    message.text = text
    message.custom_minimum_size = Vector2(800,0)
    container.add_child(name)
    container.add_child(VSeparator.new())
    container.add_child(message)
    $ScrollContainer/VBoxContainer.add_child(HSeparator.new())
    $ScrollContainer/VBoxContainer.add_child(container)
    last_message = message

func update_last_message(text="", replace=false):
    if replace: last_message.text=text
    else: last_message.text += text

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

func _on_button_pressed():
    if not waiting:
        var message = $MessageInput.text
        if validate_message(message):
            $MessageInput.clear()
            add_message("USER", message)
            waiting = true
            send_message.emit(message)


func _on_node_2d_conversation_started(character: Npc) -> void:
    _update_sprite(character)
