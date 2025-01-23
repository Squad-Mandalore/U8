extends Control

var bleed_texture = preload("res://ui/hud/assets/blood.svg")
var poison_texture = preload("res://ui/hud/assets/flask.svg")
var drug_texture = preload("res://ui/hud/assets/syringe.svg")

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
    new_health = min(new_health, max_health)
    %HealthBar.set_max_value(max_health)
    %HealthBar.set_stat_name("Gesundheit")
    %HealthBar.set_stat_number("%d/%d" % [new_health, max_health])
    %HealthBar.set_cur_value(new_health)

func update_balance(new_balance: int) -> void:
    var min_balance: int
    new_balance = max(min_balance, new_balance)
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func update_bleed(level: int) -> void:
    if level > 0:
        %BleedTexture.texture = bleed_texture
        %BleedTexture.visible = true
    else:
        %BleedTexture.texture = null

func update_poison(level: int) -> void:
    if level > 0:
        %PoisonTexture.texture = poison_texture
        %PoisonTexture.visible = true
    else:
        %PoisonTexture.texture = null

func update_drug(level: int) -> void:
    if level > 0:
        %DrugTexture.texture = drug_texture
        %DrugTexture.visible = true
    else:
        %DrugTexture.texture = null
