extends VBoxContainer

var stats_dict = {
    "max_health": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Maximale Gesundheit"
    },
    "health": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Gesundheit"
    },
    "armor": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Rüstung"
    },
    "initiative": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Initiative"
    },
    "dodge_chance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Ausweichchance"
    },
    "strength": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Stärke"
    },
    "coolness": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Coolness"
    },
    "attractiveness": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Attraktivität"
    },
    "intelligence": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Intelligenz"
    },
    "creativity": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Kreativität"
    },
    "luck": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Glück"
    },
    "poison_resistance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Giftresistenz"
    },
    "bleed_resistance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Blutungsresistenz"
    },
    "drug_resistance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Drogenresistenz"
    },
    "poison_level": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Giftlevel"
    },
    "bleed_level": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Blutungslevel"
    },
    "drug_level": {
        "texture": "res://assets/hud/ck_3_bar.svg",
        "display_name": "Drogenlevel"
    }
};

var new_stat_row_scene = preload("res://scenes/hud/components/item_info_stat_row.tscn")

func update_item_info(item: Item):
    # show()
    # %Ck3ProgressBar.texture_progress = load("res://assets/hud/ck_3_bar.svg")
    # SignalDispatcher.set_ck3_progress_bar_value.emit(%Ck3ProgressBar.value)
    # SignalDispatcher.start_timer.emit()
    set_item_name(item)
    set_item_description(item)
    remove_all_children(%StatVBox)
    set_stats(item)

func remove_all_children(parent: Node):
    for child in parent.get_children():
        child.queue_free()

func set_item_name(item: Item):
    (%ItemNameLabel as Label).text = item.name

func set_item_description(item: Item):
    (%ItemDescriptionLabel as RichTextLabel).text = item.description

func set_stats(item: Item):
    for property in item.properties.get_property_list():
        # Check if the property name exists in stats_dict
        if stats_dict.has(property.name):
            var property_value = item.properties.get(property.name)
            if property_value != 0:
                var new_stat_row = new_stat_row_scene.instantiate()
                %StatVBox.add_child(new_stat_row)
                new_stat_row.set_stat_label(property_value, stats_dict[property.name]["display_name"])
                new_stat_row.set_stat_icon(stats_dict[property.name]["texture"])

func get_ck3_progress_bar() -> TextureProgressBar:
    %Ck3ProgressBar.value = 0
    return %Ck3ProgressBar
