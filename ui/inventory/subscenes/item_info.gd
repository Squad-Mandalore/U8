extends VBoxContainer

var new_stat_row_scene = preload("res://ui/inventory/subscenes/item_info_stat_row.tscn")

func update_item_info(item: Item):
    set_item_name(item)
    set_item_description(item)
    set_item_price(item)
    Utils.remove_all_children(%StatVBox)
    set_stats(item)

func set_item_name(item: Item):
    (%ItemNameLabel as Label).text = item.name

func set_item_price(item: Item):
    var price = item.price
    if !SourceOfTruth.in_shop:
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
