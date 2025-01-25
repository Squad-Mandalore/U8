extends Control

var bleed_texture = preload("res://ui/hud/assets/white_blood.svg")
var poison_texture = preload("res://ui/hud/assets/white_flask.svg")
var drug_texture = preload("res://ui/hud/assets/white_syringe.svg")
var tokens: Array[Utils.AttackTypes]
var stance: Utils.AttackTypes = Utils.AttackTypes.Null
var stats: StatsSpecifier:
    set(value):
        stats = value
        update_status_panel()

func _ready() -> void:
    tokens.resize(3)
    tokens.fill(Utils.AttackTypes.Null)

func update_status_panel():
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
    if stance != Utils.AttackTypes.Null:
        %StanceLabel.text += Utils.AttackTypes.find_key(stance)

func update_tokens():
    for i in range(len(tokens)):
        var cur_token: NinePatchRect = get_node("%Token" + str(i + 1))
        var cur_token_str = Utils.AttackTypes.find_key(tokens[i])
        cur_token.texture = Utils.ATTACK_DICT[cur_token_str]["texture"]

func all_items_are_same(array: Array) -> bool:
    var first_item = array[0]
    for item in array:
        if item != first_item:
            return false
    return true

func update_bleed(level: int) -> void:
    if level > 0:
        %BleedTexture.texture = bleed_texture
        %BleedLabel.add_theme_color_override("font_color", Utils.RED)
    else:
        %BleedTexture.texture = null
        %BleedLabel.add_theme_color_override("font_color", Utils.GREY)

func update_poison(level: int) -> void:
    if level > 0:
        %PoisonTexture.texture = poison_texture
        %PoisonLabel.add_theme_color_override("font_color", Utils.RED)
    else:
        %PoisonTexture.texture = null
        %PoisonLabel.add_theme_color_override("font_color", Utils.GREY)

func update_drug(level: int) -> void:
    if level > 0:
        %DrugTexture.texture = drug_texture
        %DrugLabel.add_theme_color_override("font_color", Utils.RED)
    else:
        %DrugTexture.texture = null
        %DrugLabel.add_theme_color_override("font_color", Utils.GREY)

func add_token(type: Utils.AttackTypes):
    # first attacks decides initial stance
    var full = all_items_are_same(tokens)
    if full && tokens[0] == Utils.AttackTypes.Null:
        tokens[0] = type
        stance = type
        return
    # fill the tokens if its a different one
    var filled = false
    for i in range(len(tokens)):
        if tokens[i] != type:
            tokens[i] = type
            filled = true
            break
    # fill the remaining array with Null
    if filled:
        for i in range(len(tokens)):
            if tokens[i] != type:
                tokens[i] = Utils.AttackTypes.Null
