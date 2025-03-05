class_name Map
extends MetaItem

@export var price: int

func interact(_index):
	SignalDispatcher.map_opened.emit()
