extends Control

func set_stat_label(value: int, stat_specifyer: String):
    if value < 0:
        %StatNumberLabel.add_theme_color_override("font_color", Utils.red)
        %StatNameLabel.add_theme_color_override("font_color", Utils.red)
        %StatNumberLabel.text = str(value)
    else:
        %StatNumberLabel.add_theme_color_override("font_color", Utils.green)
        %StatNameLabel.add_theme_color_override("font_color", Utils.green)
        %StatNumberLabel.text = "+" + str(value)

    %StatNameLabel.text = stat_specifyer

func hide_separator_and_margin():
    $VBoxContainer/MarginContainer.hide()
    $VBoxContainer/HSeparator.hide()
    $VBoxContainer/MarginContainer2.hide()

func set_stat_icon(texture: String):
    %StatSymbol.texture = load(texture)
    %StatSymbol.size = Vector2(24, 24)
