extends Label

func set_side(is_left: bool):
    if is_left:
        add_theme_stylebox_override("normal", preload("res://scenes/dialogue/assets/chat_ui_left.tres"))
    else:
        add_theme_stylebox_override("normal", preload("res://scenes/dialogue/assets/chat_ui_right.tres"))

func add_new_text(text: String):
    self.text = text
    var parent_width = 921
    var font = get_theme_font("font")
    var content_width = font.get_string_size(text).x
    custom_minimum_size.x = min(content_width, parent_width)
    print(parent_width)
    print(content_width)
