class_name Attack
extends Resource

@export var name: String
@export var damage: int
@export_enum("Attraktiv", "Stark", "Cool", "Intelligent", "Kreativ") var type: String
@export_enum("Attraktiv", "Stark", "Cool", "Intelligent", "Kreativ") var token: String
@export var token_number: int
# TODO: effect logic with probably not String but enum or int
@export var effect: String
