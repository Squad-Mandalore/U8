class_name Attack
extends Resource

@export var name: String
@export var damage: int
@export var type: Utils.AttackTypes
@export var token: Utils.AttackTypes
@export var token_number: int
# TODO: effect logic with probably not String but enum or int
@export var effect: String
@export var damage_multiplier: float

func _to_string() -> String:
    return """Attack Details:
    Name: %s
    Damage: %d
    Type: %s
    Token: %s
    Token Number: %d
    Effect: %s
    Damage Multiplier: %.2f
    """ % [name, damage, str(type), str(token), token_number, effect, damage_multiplier]
