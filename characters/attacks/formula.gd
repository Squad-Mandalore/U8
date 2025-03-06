class_name Formula
extends Resource

@export var base: int
@export var max_health_modifier: float
@export var health_modifier: float
@export var armor_modifier: float
@export var initiative_modifier: float
@export var dodge_chance_modifier: float
@export var strength_modifier: float
@export var coolness_modifier: float
@export var attractiveness_modifier: float
@export var intelligence_modifier: float
@export var creativity_modifier: float
# @export var radicality_modifier: float
@export var luck_modifier: float
@export var poison_resistance_modifier: float
@export var bleed_resistance_modifier: float
@export var drug_resistance_modifier: float
@export var poison_level_modifier: float
@export var bleed_level_modifier: float
@export var drug_level_modifier: float
@export var effect_modifier: float = 1
@export var effect_flat_modifier: int

func _to_string() -> String:
    return """Formula Details:
Base: %d
Max Health Modifier: %.2f
Health Modifier: %.2f
Armor Modifier: %.2f
Initiative Modifier: %.2f
Dodge Chance Modifier: %.2f
Strength Modifier: %.2f
Coolness Modifier: %.2f
Attractiveness Modifier: %.2f
Intelligence Modifier: %.2f
Creativity Modifier: %.2f
Luck Modifier: %.2f
Poison Resistance Modifier: %.2f
Bleed Resistance Modifier: %.2f
Drug Resistance Modifier: %.2f
Poison Level Modifier: %.2f
Bleed Level Modifier: %.2f
Drug Level Modifier: %.2f
Effect Modifier: %.2f
Effect Flat Modifier: %d""" % [
        base,
        max_health_modifier,
        health_modifier,
        armor_modifier,
        initiative_modifier,
        dodge_chance_modifier,
        strength_modifier,
        coolness_modifier,
        attractiveness_modifier,
        intelligence_modifier,
        creativity_modifier,
        luck_modifier,
        poison_resistance_modifier,
        bleed_resistance_modifier,
        drug_resistance_modifier,
        poison_level_modifier,
        bleed_level_modifier,
        drug_level_modifier,
        effect_modifier,
        effect_flat_modifier
    ]

