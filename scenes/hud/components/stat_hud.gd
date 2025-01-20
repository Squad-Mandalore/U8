extends Control

var stats: StatsSpecifier = null
var ck3_progress_bar_value: int

func _ready() -> void:
    SignalDispatcher.set_ck3_progress_bar_value.connect(set_ck3_progress_bar_value)

func set_ck3_progress_bar_value(value: int):
    ck3_progress_bar_value = value

func update_inventory_stat_hud(stats: StatsSpecifier):
    self.stats = stats
    update_health(stats.health, stats.max_health)
    update_dodge_chance(stats.dodge_chance, 50)
    update_armor(stats.armor)
    update_initiative(stats.initiative)
    update_strength(stats.strength)
    update_coolness(stats.coolness)
    update_attractiveness(stats.attractiveness)
    update_intelligence(stats.intelligence)
    update_creativity(stats.creativity)
    update_luck(stats.luck)
    update_bleed_resistance(stats.bleed_resistance)
    update_poison_resistance(stats.poison_resistance)
    update_drug_resistance(stats.drug_resistance)


func update_health(new_health: int, max_health: int) -> void:
    new_health = min(new_health, max_health)
    %HealthBar.set_max_value(max_health)
    %HealthBar.set_stat_name("Gesundheit")
    %HealthBar.set_stat_number("%d/%d" % [new_health, max_health])
    %HealthBar.set_cur_value(new_health)

func update_dodge_chance(new_dodge_chance: int, max_dodge_chance: int) -> void:
    new_dodge_chance = min(new_dodge_chance, max_dodge_chance)
    %DodgeChanceBar.set_max_value(max_dodge_chance)
    %DodgeChanceBar.set_stat_name("Ausweichchance")
    %DodgeChanceBar.set_stat_number("%d/%d" % [new_dodge_chance, max_dodge_chance])
    %DodgeChanceBar.set_cur_value(new_dodge_chance)

func update_armor(armor: int):
    (%LabelArmorStat as Label).text = str(armor)

func update_initiative(initiative: int):
    (%LabelInitiativeStat as Label).text = str(initiative)

func update_strength(strength: int):
    (%LabelStrengthStat as Label).text = str(strength)

func update_coolness(coolness: int):
    (%LabelCoolnessStat as Label).text = str(coolness)

func update_attractiveness(attractiveness: int):
    (%LabelAttractivenessStat as Label).text = str(attractiveness)

func update_intelligence(intelligence: int):
    (%LabelIntelligenceStat as Label).text = str(intelligence)

func update_creativity(creativity: int):
    (%LabelCreativityStat as Label).text = str(creativity)

func update_luck(luck: int):
    (%LabelLuckStat as Label).text = str(luck)

func update_bleed_resistance(bleedResistance: int):
    (%LabelBleedResistanceStat as Label).text = str(bleedResistance) + "%"
    if bleedResistance == 100:
        (%LabelBleedResistanceStat as Label).add_theme_color_override("font_color", Utils.LIGHT_BLUE)

func update_poison_resistance(poisonResistance: int):
    (%LabelPoisonResistanceStat as Label).text = str(poisonResistance) + "%"
    if poisonResistance == 100:
        (%LabelPoisonResistanceStat as Label).add_theme_color_override("font_color", Utils.LIGHT_BLUE)

func update_drug_resistance(drugResistance: int):
    (%LabelDrugResistanceStat as Label).text = str(drugResistance) + "%"
    if drugResistance == 100:
        (%LabelDrugResistanceStat as Label).add_theme_color_override("font_color", Utils.LIGHT_BLUE)

func _on_resistance_info_v_box_mouse_exited() -> void:
    if ck3_progress_bar_value != 60:
        SignalDispatcher.toggle_resistance_hud.emit(null)

func _on_resistance_info_v_box_mouse_entered() -> void:
    SignalDispatcher.toggle_resistance_hud.emit(stats)

