class_name Consumable
extends InventoryItem

@export var effect_duration: int

func interact(i: int):
    SourceOfTruth.stats_changed(stats)
    SourceOfTruth.remove_item(i)
