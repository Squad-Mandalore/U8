class_name Map
extends MetaItem

func interact(_index):
    SignalDispatcher.map_opened.emit()
