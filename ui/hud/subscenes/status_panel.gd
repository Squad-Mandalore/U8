extends Control

var bleed_texture = preload("res://ui/hud/assets/blood.svg")
var poison_texture = preload("res://ui/hud/assets/flask.svg")
var drug_texture = preload("res://ui/hud/assets/syringe.svg")
var grey_bleed_texture = preload("res://ui/hud/assets/grey_blood.svg")
var grey_poison_texture = preload("res://ui/hud/assets/grey_flask.svg")
var grey_drug_texture = preload("res://ui/hud/assets/grey_syringe.svg")

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_status_panel)

func update_status_panel():
    var stats = SourceOfTruth.stats
    update_health(stats.health, stats.max_health)
    update_balance(SourceOfTruth.balance)
    update_bleed(stats.bleed_level)
    update_poison(stats.poison_level)
    update_drug(stats.drug_level)

func update_health(new_health: int, max_health: int) -> void:
    %HealthBar.set_stat_name("Gesundheit")
    %HealthBar.set_stat(new_health, max_health)

func update_balance(new_balance: int) -> void:
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func update_bleed(level: int) -> void:
    if level > 0:
        %BleedTexture.texture = bleed_texture
    else:
        %BleedTexture.texture = grey_bleed_texture

func update_poison(level: int) -> void:
    if level > 0:
        %PoisonTexture.texture = poison_texture
    else:
        %PoisonTexture.texture = grey_poison_texture

func update_drug(level: int) -> void:
    if level > 0:
        %DrugTexture.texture = drug_texture
    else:
        %DrugTexture.texture = grey_drug_texture
