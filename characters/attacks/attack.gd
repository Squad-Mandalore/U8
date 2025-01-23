class_name Attack
extends Resource

@export var name: String
@export var damage: int
@export var type: Utils.AttackTypes
@export var token: Utils.AttackTypes
@export var token_number: int
# TODO: effect logic with probably not String but enum or int
@export var effect: String
