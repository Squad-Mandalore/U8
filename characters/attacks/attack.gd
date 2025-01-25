class_name Attack
extends Resource

@export var name: String
@export var damage: int
@export var type: Utils.AttackTypes
@export var token: Utils.AttackTypes
@export var token_number: int
# TODO: effect logic with probably not String but enum or int
@export var effect: String
@export var formula: Formula

func _to_string() -> String:
    return """Attack Details:
    Name: %s
    Damage: %d
    Type: %s
    Token: %s
    Token Number: %d
    Effect: %s
    Damage Multiplier: %.2f
    """ % [name, damage, str(type), str(token), token_number, effect]

func calculate_damage(stats: StatsSpecifier):
    damage = (
        stats.max_health * formula.max_health_modifier +
        stats.health * formula.health_modifier +
        stats.armor * formula.armor_modifier +
        stats.initiative * formula.initiative_modifier +
        stats.dodge_chance * formula.dodge_chance_modifier +
        stats.strength * formula.strength_modifier +
        stats.coolness * formula.coolness_modifier +
        stats.attractiveness * formula.attractiveness_modifier +
        stats.intelligence * formula.intelligence_modifier +
        stats.creativity * formula.creativity_modifier +
        stats.luck * formula.luck_modifier +
        stats.poison_resistance * formula.poison_resistance_modifier +
        stats.bleed_resistance * formula.bleed_resistance_modifier +
        stats.drug_resistance * formula.drug_resistance_modifier +
        stats.poison_level * formula.poison_level_modifier +
        stats.bleed_level * formula.bleed_level_modifier +
        stats.drug_level * formula.drug_level_modifier
    ) * formula.effect_modifier + formula.effect_flat_modifier + formula.base

