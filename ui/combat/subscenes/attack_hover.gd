extends Control
class_name AttackHover

@onready var panel_container = $PanelContainer

func _ready() -> void:
    # width / 2 - 20 = 171
    # height - 2 = 253
    $Polygon2D.global_position = global_position + Vector2(panel_container.size.x / 2 - 20, panel_container.size.y - 2)

func update_attack_hover(attack: Attack):
    update_name(attack.name)
    update_type(attack.type)
    update_damage(attack.damage)
    update_token(attack.token, attack.token_number)
    update_effect(attack.effect)

func update_name(name: String):
    %NameLabel.text = name

func update_damage(damage: int):
    %DamageLabel.text = str(damage)+ " Schaden"

func update_type(type_index: Utils.AttackTypes):
    var type: String = Utils.AttackTypes.find_key(type_index)
    %TypeLabel.text = type
    %TypeLabel.add_theme_color_override("font_color", Utils.ATTACK_DICT[type]["color"])

func update_token(token_index: Utils.AttackTypes, token_number: int):
    var token: String = Utils.AttackTypes.find_key(token_index)
    %TokenLabel.text = "+" + str(token_number) + " " + token
    %TokenLabel.add_theme_color_override("font_color", Utils.ATTACK_DICT[token]["color"])

func update_effect(effect: String):
    %EffectLabel.text = "Effekt: " + effect
    if effect.is_empty():
        %EffectSeparator.hide()
        %EffectHBox.hide()
