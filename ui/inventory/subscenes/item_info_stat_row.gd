extends Control

func set_stat_label(value: int, stat_specifyer: String):
    if value < 0:
        %StatNumberLabel.add_theme_color_override("font_color", Utils.RED)
        %StatNameLabel.add_theme_color_override("font_color", Utils.RED)
        %StatNumberLabel.text = str(value)
    else:
        %StatNumberLabel.add_theme_color_override("font_color", Utils.GREEN)
        %StatNameLabel.add_theme_color_override("font_color", Utils.GREEN)
        %StatNumberLabel.text = "+" + str(value)

    %StatNameLabel.text = stat_specifyer

func hide_separator_and_margin():
    $VBoxContainer/MarginContainer.hide()
    $VBoxContainer/HSeparator.hide()
    $VBoxContainer/MarginContainer2.hide()

func set_stat_icon(texture: Texture):
    %StatSymbol.texture = texture
    %StatSymbol.size = Vector2(24, 24)
