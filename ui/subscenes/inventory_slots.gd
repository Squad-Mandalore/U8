extends VBoxContainer

func _ready() -> void:
    SignalDispatcher.update_item_slots.connect(load_item_slots)

func load_item_slots():
    for i in range(SourceOfTruth.MAX_INVENTORY_SIZE):
        var item_slot = get_node("%ItemSlot" + str(i + 1))
        item_slot.index = i
        if i + 1 > SourceOfTruth.cur_inventory_size:
            item_slot.disable()
        else:
            item_slot.enable()
            item_slot.set_item(SourceOfTruth.inventory_slots[i])
