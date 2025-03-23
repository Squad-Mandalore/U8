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
    
    autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    
    var content_width = font.get_string_size(new_text).x
    
    if content_width < parent_width * 0.6:
        size_flags_horizontal = SIZE_SHRINK_BEGIN
        custom_minimum_size.x = min(content_width + 50, parent_width * 0.6)
    else:
        size_flags_horizontal = SIZE_FILL
        custom_minimum_size.x = parent_width * 0.7
    
    size = Vector2.ZERO
    custom_minimum_size.y = 0
    
    call_deferred("_update_layout")

func _update_layout():
    if get_parent():
        get_parent().queue_sort()
    queue_redraw()
