extends Control

# Time interval in seconds
var interval: float = 0.001
# Tracks the remaining time
var timer: float = 0.0
var is_timer_active: bool = false

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

func _ready() -> void:
    hide()
    SignalDispatcher.update_item_hud.connect(update_component)

func _process(delta: float) -> void:
    # Decrease the timer by the frame's delta time
    if is_timer_active:
            timer -= delta
            if timer <= 0.0:
                timer += interval # Reset the timer (for repetitive calls)
                _on_timer_timeout()

func update_component(item: Item):
    if item == null:
        hide()
        return
    show()
    %Ck3ProgressBar.value = 0
    %Ck3ProgressBar.texture_progress = load("res://assets/hud/ck_3_bar.svg")
    SignalDispatcher.set_ck3_progress_bar_value.emit(%Ck3ProgressBar.value)
    start_timer()
    set_item_name(item)
    set_item_description(item)
    remove_all_children(%StatVBox)
    set_stats(item)

func set_item_name(item: Item):
    (%ItemNameLabel as Label).text = item.name

func set_item_description(item: Item):
    (%ItemDescriptionLabel as RichTextLabel).text = item.description

func remove_all_children(parent: Node):
    for child in parent.get_children():
        child.queue_free()

func set_stats(item: Item):
    for property in item.properties.get_property_list():
        # Check if the property name exists in stats_dict
        if stats_dict.has(property.name):
            var property_value = item.properties.get(property.name)
            if property_value != 0:
                var new_stat_row_scene = preload("res://scenes/hud/components/item_description_stat_row.tscn")
                var new_stat_row = new_stat_row_scene.instantiate()
                %StatVBox.add_child(new_stat_row)
                new_stat_row.set_stat_label(property_value, stats_dict[property.name]["display_name"])
                new_stat_row.set_stat_icon(stats_dict[property.name]["texture"])

func _on_timer_timeout() -> void:
    if %Ck3ProgressBar.value == %Ck3ProgressBar.max_value:
        %Ck3ProgressBar.texture_progress = load("res://assets/hud/ck_3_bar_close.svg")
        SignalDispatcher.set_ck3_progress_bar_value.emit(%Ck3ProgressBar.value)
        stop_timer()
        return

    %Ck3ProgressBar.value += 1

func start_timer(new_interval: float = -1.0) -> void:
    if new_interval > 0.0:
        interval = new_interval
    timer = interval
    is_timer_active = true

# Stop the timer
func stop_timer() -> void:
    is_timer_active = false
