extends Control

@export var is_human: bool
var _dialogue_box: RichTextLabel

func _ready() -> void:
    if is_human:
        _dialogue_box = %HumanLabel
        %HumanShopUpper.show()
        %HumanShopLower.show()
        %MachineContainer.hide()
    else:
        _dialogue_box = %MachineLabel
        %MachineContainer.show()
        %HumanShopUpper.hide()
        %HumanShopLower.hide()
