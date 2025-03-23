extends Label

var is_left: bool = false

func set_side(is_left: bool):
    self.is_left = is_left
    
    if is_left:
        # Chatbot messages (left side)
        add_theme_stylebox_override("normal", preload("res://scenes/dialogue/assets/chat_ui_left.tres"))
        # Set horizontal alignment to left
        size_flags_horizontal = SIZE_FILL
        horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
        # Add left margin for spacing
        add_theme_constant_override("margin_left", 10)
        add_theme_constant_override("margin_right", 100)  # Leave space on right
    else:
        # Player messages (right side)
        add_theme_stylebox_override("normal", preload("res://scenes/dialogue/assets/chat_ui_right.tres"))
        # Set horizontal alignment to right
        size_flags_horizontal = SIZE_FILL
        horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
        # Add right margin for spacing
        add_theme_constant_override("margin_right", 10)
        add_theme_constant_override("margin_left", 100)  # Leave space on left

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
