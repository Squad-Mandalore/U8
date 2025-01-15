extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_stats(stats: StatsSpecifier):
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
    update_bleedResistance(stats.bleed_resistance)
    update_poisonResistance(stats.poison_resistance)
    update_drugResistance(stats.drug_resistance)


func update_health(new_health: int, max_health: int) -> void:
    new_health = min(new_health, max_health)
    (%HealthBar as TextureProgressBar).max_value = max_health
    (%LabelHealthStat as Label).text = "%d/%d" % [new_health, max_health]
    (%HealthBar as TextureProgressBar).value = new_health

func update_dodge_chance(new_dodge_chance: int, max_dodge_chance: int) -> void:
    new_dodge_chance = min(new_dodge_chance, max_dodge_chance)
    (%DodgeChanceBar as TextureProgressBar).max_value = max_dodge_chance
    (%LabelDodgeChanceStat as Label).text = "%d/%d" % [new_dodge_chance, max_dodge_chance]
    (%DodgeChanceBar as TextureProgressBar).value = new_dodge_chance

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

func update_bleedResistance(bleedResistance: int):
    (%LabelBleedResistanceStat as Label).text = str(bleedResistance) + "%"

func update_poisonResistance(poisonResistance: int):
    (%LabelPoisonResistanceStat as Label).text = str(poisonResistance) + "%"

func update_drugResistance(drugResistance: int):
    (%LabelDrugResistanceStat as Label).text = str(drugResistance) + "%"
