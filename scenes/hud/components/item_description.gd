extends Control

func update_component(item: Item):
    set_item_name(item)
    set_item_description(item)

func set_item_name(item: Item):
    (%ItemNameLabel as Label).text = item.name

func set_item_description(item: Item):
    (%ItemDescriptionLabel as RichTextLabel).text = item.description
