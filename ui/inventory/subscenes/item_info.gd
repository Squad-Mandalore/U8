extends VBoxContainer

var new_stat_row_scene = preload("res://ui/inventory/subscenes/item_info_stat_row.tscn")
@onready var _desription_box = $HBoxContainer3
@onready var _attack_container = $AttackContainer

func update_item_info(item: Item, is_shop_slot: bool):
    set_item_name(item)
    set_item_description(item)
    set_item_price(item, is_shop_slot)
    Utils.remove_all_children(%StatVBox)
    set_stats(item)
    if item is Weapon:
        _handle_weapon(item)

func set_item_name(item: Item):
    (%ItemNameLabel as Label).text = item.name

func set_item_price(item: Item, is_shop_slot: bool):
    var price = item.price
    if !is_shop_slot:
        price = SourceOfTruth.calculate_selling_price(item.price)

    %CostsLabel.text = str(price) + " Euronen"

func set_item_description(item: Item):
    (%ItemDescriptionLabel as RichTextLabel).text = item.description

func set_stats(item: Item):
    for property in item.stats.get_property_list():
        # Check if the property name exists in stats_dict
        if Utils.STATS_DICT.has(property.name):
            var property_value = item.stats.get(property.name)
            if property_value != 0:
                var new_stat_row = new_stat_row_scene.instantiate()
                %StatVBox.add_child(new_stat_row)
                new_stat_row.set_stat_label(property_value, Utils.STATS_DICT[property.name]["display_name"])
                new_stat_row.set_stat_icon(Utils.STATS_DICT[property.name]["texture"])

func get_ck3_progress_bar() -> TextureProgressBar:
    %Ck3ProgressBar.value = 0
    return %Ck3ProgressBar

func _handle_weapon(item: Weapon):
    _desription_box.hide()
    _attack_container.show()
    %AttackSwapper.max_attacks = 2 # this line MUST be executed before the attacks are set
    %AttackSwapper.attacks = item.attacks
    %AttackSwapper.change_margin(Vector4(0,0,0,0))

