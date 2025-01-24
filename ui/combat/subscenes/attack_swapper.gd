extends Control

var attacks: Array[Attack]:
    set(value):
        attacks = value
        set_attacks()

func set_attack(index: int, attack: Attack):
    get_node("%Attack" + str(index + 1)).attack = attack

func set_attacks():
    for i in range(3):
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
    move_first_to_last(attacks)
    set_attacks()

func _on_swap_button_right_pressed() -> void:
    move_last_to_first(attacks)
    set_attacks()
