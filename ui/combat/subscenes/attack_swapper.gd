extends Control

@onready var _animation_player = $AnimationPlayer
@onready var _margin_container: MarginContainer = $PanelContainer/MarginContainer

var _attacks_to_show: int
var max_attacks: int = 3

var attacks: Array[Attack]:
    set(value):
        _attacks_to_show = min(value.size(), max_attacks)
        attacks = value
        set_attacks()

func set_attack(index: int, attack: Attack):
    var node = get_node("%Attack" + str(index + 1))
    node.attack = attack
    node.show()

func set_attacks():
    for i in range(_attacks_to_show):
        set_attack(i, attacks[i])

func move_first_to_last(arr):
    if arr.size() > 0:
        var first_element = arr.pop_front()
        arr.append(first_element)
    return arr

func move_last_to_first(arr):
    if arr.size() > 0:
        var last_element = arr.pop_back()
        arr.insert(0, last_element)
    return arr

func _on_swap_button_left_pressed() -> void:
    _animation_player.play("fade_out")
    move_first_to_last(attacks)

func _on_swap_button_right_pressed() -> void:
    _animation_player.play("fade_out")
    move_last_to_first(attacks)


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    if anim_name == "fade_out":
        set_attacks()
        _animation_player.play("fade_in")

func change_margin(margin: Vector4):
    _margin_container.add_theme_constant_override("margin_left", margin.x)
    _margin_container.add_theme_constant_override("margin_top", margin.y)
    _margin_container.add_theme_constant_override("margin_right", margin.z)
    _margin_container.add_theme_constant_override("margin_bottom", margin.w)
