extends Label

func set_side(is_left: bool):
    if is_left:
        add_theme_stylebox_override("normal", preload("res://scenes/dialogue/assets/chat_ui_left.tres"))
    else:
        add_theme_stylebox_override("normal", preload("res://scenes/dialogue/assets/chat_ui_right.tres"))

func add_new_text(new_text: String):
    self.text = new_text
    var parent_width = 921
    var font = get_theme_font("font")
    var content_width = font.get_string_size(new_text).x
    # TODO: custom minimum size ist hier evtl. nicht die beste Wahl
    custom_minimum_size.x = min(content_width, parent_width)
