extends Control

var is_human: bool
var _dialogue_box: RichTextLabel
var shop_inventory: Array[Item]
var shop_inventory_size: int = 8
@onready var shop_name_label = %ShopNameLabel
var human_dialogues = [
    "Nur {price} Euronen, wat willste mehr?",
    "Ey, {price} Euronen? Is geschenkt!",
    "Für {price} Euronen kriegste dit nirgends!",
    "Dit Ding? {price} Euronen, nimmste?",
    "Für {price} Euronen mach ick dir ’n Freundschaftspreis!",
    "{price} Euronen, dit is echt fair!",
    "Mit {price} Euronen biste King, sach ick!",
    "Nur {price} Euronen, dit is der Hammer!",
    "Alter, {price} Euronen, wat ein Deal!",
    "{price} Euronen. Dit Ding is der Knaller!"
]

var machine_dialogues = [
    "Bzzt... Bup bzz bzz. Krrrzt... {price}... Brr bzzzt!",
    "Kzzzt bzzt bzzt... Brrp {price}. Bup krrr... Bzzt bzz!",
    "Bzzt bzz... Krrr bup-bup... {price}... Brrzt kzz!",
    "Krrrzt bzzt brr... {price}... Bup-bzzzt brrr!",
    "Bzz-bzz... Krrzt {price}... Bup bup bzzt krrr!",
    "Bup... Kzz bzz bzzzt... {price}... Krrr bzzt bzzt!",
    "Krrrzt bzz... {price}... Brr bzz bzz bup!",
    "Bzzzt krrr... Bzz bup bup {price}... Kzzzt bzz!",
    "Bup bup bzzzt... {price}... Krrr bzz brrr!",
    "Kzzzt bzzzt brr... Bup-bup {price}... Brr bzz!"
]

func _ready() -> void:
    SignalDispatcher.update_shop_item_slots.connect(update_item_slots)
    SignalDispatcher.update_shop_dialogue_box.connect(update_dialogue_box)
    for i in range(shop_inventory_size):
        var node = "%ShopSlot" + str(i + 1)
        var shop_inventory_slot = get_node(node)
        shop_inventory_slot.is_shop_slot = true
        shop_inventory_slot.index = i + 1

func reload(new_is_human: bool, new_shop_inventory: Array[Item], shop_name: String, sprite_frames: SpriteFrames = null) -> void:
    is_human = new_is_human
    shop_inventory = new_shop_inventory
    shop_name_label.text = shop_name
    if is_human:
        _dialogue_box = %HumanLabel
        %HumanShopUpper.show()
        %HumanShopLower.show()
        %MachineContainer.hide()
        %AnimatedSprite2D.sprite_frames = sprite_frames
        %AnimatedSprite2D.animation = "shop"
        %AnimatedSprite2D.play()
    else:
        _dialogue_box = %MachineLabel
        %MachineContainer.show()
        %HumanShopUpper.hide()
        %HumanShopLower.hide()
    _dialogue_box.text = "..."

    update_item_slots()


func update_item_slots(to_free: int = -1):
    for i in range(shop_inventory_size):
        var node = "%ShopSlot" + str(i + 1)
        var shop_inventory_slot = get_node(node)
        if i + 1 == to_free:
            shop_inventory[i] = null
        if shop_inventory[i]:
            shop_inventory_slot.set_item(shop_inventory[i])
        else:
            shop_inventory_slot.disable()

func update_dialogue_box(item: Item):
    var formatted_price: String
    if SourceOfTruth.balance >= item.price:
        formatted_price = "[color=" + Utils.GREEN.to_html() + "]" + str(item.price) + "[/color]"
    else:
        formatted_price = "[color=" + Utils.RED.to_html() + "]" + str(item.price) + "[/color]"
    if is_human:
        _dialogue_box.text = human_dialogues[randi() % human_dialogues.size()].format({"price": formatted_price})
    else:
        _dialogue_box.text = machine_dialogues[randi() % machine_dialogues.size()].format({"price": formatted_price})
