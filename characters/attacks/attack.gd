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

func calculate_damage():
    damage = (
        SourceOfTruth.stats.max_health * formula.max_health_modifier +
        SourceOfTruth.stats.health * formula.health_modifier +
        SourceOfTruth.stats.armor * formula.armor_modifier +
        SourceOfTruth.stats.initiative * formula.initiative_modifier +
        SourceOfTruth.stats.dodge_chance * formula.dodge_chance_modifier +
        SourceOfTruth.stats.strength * formula.strength_modifier +
        SourceOfTruth.stats.coolness * formula.coolness_modifier +
        SourceOfTruth.stats.attractiveness * formula.attractiveness_modifier +
        SourceOfTruth.stats.intelligence * formula.intelligence_modifier +
        SourceOfTruth.stats.creativity * formula.creativity_modifier +
        SourceOfTruth.stats.luck * formula.luck_modifier +
        SourceOfTruth.stats.poison_resistance * formula.poison_resistance_modifier +
        SourceOfTruth.stats.bleed_resistance * formula.bleed_resistance_modifier +
        SourceOfTruth.stats.drug_resistance * formula.drug_resistance_modifier +
        SourceOfTruth.stats.poison_level * formula.poison_level_modifier +
        SourceOfTruth.stats.bleed_level * formula.bleed_level_modifier +
        SourceOfTruth.stats.drug_level * formula.drug_level_modifier
    ) * formula.effect_modifier + formula.effect_flat_modifier + formula.base

