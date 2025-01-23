extends Control

var attack: Attack:
    set(value):
        attack = value
        update_name(attack.name)
        update_type(attack.type)
        update_damage(attack.damage)
        update_token(attack.token, attack.token_number)
        update_icon(attack.effect)

func _ready() -> void:
    attack = preload("res://characters/attacks/assets/tail_whip.tres")

func _on_panel_container_mouse_exited() -> void:
    $PanelContainer.add_theme_stylebox_override("panel", preload("res://ui/combat/assets/attack.tres"))
    SignalDispatcher.remove_attack_hover.emit()

func _on_panel_container_mouse_entered() -> void:
    $PanelContainer.add_theme_stylebox_override("panel", preload("res://ui/combat/assets/attack_on_hover.tres"))
    # 285 = Height of attack hover 255px + 20 px triangle + 10 px margin
    # 113 = width of attack hover/2 382/2 (191) - half of attack width 156/2 (78)
    var jens_span: Vector2 = global_position - Vector2(113, 285)
    if attack.effect.is_empty():
        jens_span = global_position - Vector2(113, 200)

    SignalDispatcher.add_attack_hover.emit(jens_span, attack)

func update_name(name: String):
    %NameLabel.text = name

func update_damage(damage: int):
    %DamageLabel.text = str(damage)+ " Schaden"

func update_type(type: String):
    %TypeLabel.text = type
    %TypeLabel.add_theme_color_override("font_color", Utils.ATTACK_DICT[type])

func update_token(token: String, token_number: int):
    %TokenLabel.text = "+" + str(token_number) + " " + token
    %TokenLabel.add_theme_color_override("font_color", Utils.ATTACK_DICT[token])

func update_icon(effect: String):
    if effect.is_empty():
        %EffectIcon.hide()
