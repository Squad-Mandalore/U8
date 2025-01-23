extends Control

var bleed_texture = preload("res://ui/hud/assets/white_blood.svg")
var poison_texture = preload("res://ui/hud/assets/white_flask.svg")
var drug_texture = preload("res://ui/hud/assets/white_syringe.svg")
var tokens = Array[Utils.AttackTypes]
var stance: Utils.AttackTypes

func _ready() -> void:
    SignalDispatcher.reload_ui.connect(update_status_panel)

func update_status_panel(stats: StatsSpecifier):
    update_health(stats.health, stats.max_health)
    update_bleed(stats.bleed_level)
    update_poison(stats.poison_level)
    update_drug(stats.drug_level)

func update_health(new_health: int, max_health: int) -> void:
    new_health = min(new_health, max_health)
    %HealthBar.set_max_value(max_health)
    %HealthBar.set_stat_name("Gesundheit")
    %HealthBar.set_stat_number("%d/%d" % [new_health, max_health])
    %HealthBar.set_cur_value(new_health)

func update_stance():
    %StanceLabel.text = "Kampfhaltung: "
    if stance:
        return

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
