class_name StatsSpecifier
extends Resource

@export var max_health: int
@export var health: int
@export var armor: int
@export var initiative: int
@export var dodge_chance: int
@export var strength: int
@export var coolness: int
@export var attractiveness: int
@export var intelligence: int
@export var creativity: int
# @export var radicality: int
@export var luck: int
# Resistances in %. 100% Resistance means no dmg taken anymore.
@export var poison_resistance: int
@export var bleed_resistance: int
@export var drug_resistance: int
@export var poison_level: int
@export var bleed_level: int
@export var drug_level: int

func add(stats: StatsSpecifier):
    max_health += stats.max_health
    health += stats.health
    armor += stats.armor
    initiative += stats.initiative
    dodge_chance += stats.dodge_chance
    strength += stats.strength
    coolness += stats.coolness
    attractiveness += stats.attractiveness
    intelligence += stats.intelligence
    creativity += stats.creativity
    # Uncomment if radicality is added in future
    # radicality += stats.radicality
    luck += stats.luck
    poison_resistance += stats.poison_resistance
    bleed_resistance += stats.bleed_resistance
    drug_resistance += stats.drug_resistance
    poison_level += stats.poison_level
    bleed_level += stats.bleed_level
    drug_level += stats.drug_level

func _to_string() -> String:
    return """Stats:
    Max Health: %d
    Health: %d
    Armor: %d
    Initiative: %d
    Dodge Chance: %d
    Strength: %d
    Coolness: %d
    Attractiveness: %d
    Intelligence: %d
    Creativity: %d
    Luck: %d
    Poison Resistance: %d
    Bleed Resistance: %d
    Drug Resistance: %d
    Poison Level: %d
    Bleed Level: %d
    Drug Level: %d
    """ % [max_health, health, armor, initiative, dodge_chance, strength, coolness, attractiveness, intelligence, creativity, luck, poison_resistance, bleed_resistance, drug_resistance, poison_level, bleed_level, drug_level]

