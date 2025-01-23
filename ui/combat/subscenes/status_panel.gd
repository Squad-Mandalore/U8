extends Control

var bleed_texture = preload("res://ui/hud/assets/white_blood.svg")
var poison_texture = preload("res://ui/hud/assets/white_flask.svg")
var drug_texture = preload("res://ui/hud/assets/white_syringe.svg")
var tokens: Array[Utils.AttackTypes]
var stance: Utils.AttackTypes

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_status_panel)
    tokens.resize(3)
    tokens.fill(null)

func update_status_panel():
    var stats = SourceOfTruth.stats
    update_health(stats.health, stats.max_health)
    update_bleed(stats.bleed_level)
    update_poison(stats.poison_level)
    update_drug(stats.drug_level)
    update_stance()
    update_tokens()

func update_health(new_health: int, max_health: int) -> void:
    new_health = min(new_health, max_health)
    %HealthBar.set_max_value(max_health)
    %HealthBar.set_stat_name("Gesundheit")
    %HealthBar.set_stat_number("%d/%d" % [new_health, max_health])
    %HealthBar.set_cur_value(new_health)

func update_stance():
    if all_items_are_same(tokens):
        stance = tokens[0]

    %StanceLabel.text = "Kampfhaltung: "
    if stance:
        %StanceLabel.text += Utils.AttackTypes.find_key(stance)

func update_tokens():
    for i in range(len(tokens)):
        var cur_token: NinePatchRect = get_node("%Token" + str(i + 1))
        if tokens[i] == null:
            cur_token.texture = preload("res://ui/combat/assets/stance_token_white.svg")
        else:
            cur_token.texture = Utils.ATTACK_DICT[Utils.AttackTypes.find_key(tokens[i])]["texture"]

func all_items_are_same(array: Array) -> bool:
    var first_item = array[0]
    for item in array:
        if item != first_item:
            return false
    return true

func update_bleed(level: int) -> void:
    if level > 0:
        %BleedTexture.texture = bleed_texture
        %BleedTexture.show()
        %BleedLabel.show()
    else:
        %BleedTexture.texture = null
        %BleedLabel.hide()

func update_poison(level: int) -> void:
    if level > 0:
        %PoisonTexture.texture = poison_texture
        %PoisonTexture.show()
        %PoisonLabel.show()
    else:
        %PoisonTexture.texture = null
        %PoisonLabel.hide()

func update_drug(level: int) -> void:
    if level > 0:
        %DrugTexture.texture = drug_texture
        %DrugTexture.show()
        %DrugLabel.show()
    else:
        %DrugTexture.texture = null
        %DrugLabel.hide()
