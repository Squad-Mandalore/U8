extends Control

@export var is_human: bool
var _dialogue_box: RichTextLabel

func _ready() -> void:
    if is_human:
        _dialogue_box = %HumanLabel
        %HumanVBox.show()
        %HumanMargin.show()
        %MachineHBox.hide()
        %MachineLabel.hide()
    else:
        _dialogue_box = %MachineLabel
        %MachineHBox.show()
        %MachineLabel.show()
        %HumanVBox.hide()
        %HumanMargin.hide()
