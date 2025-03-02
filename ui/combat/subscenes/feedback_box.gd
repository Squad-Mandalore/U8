extends Control

@onready var rich_text_label = $PanelContainer/MarginContainer/FeedbackLabel
@onready var animation_player = $PanelContainer/MarginContainer/AnimationPlayer

func set_feedback(feedback: String):
    animation_player.stop()
    rich_text_label.text = feedback
    animation_player.play("typewriter")
