class_name Attack
extends Resource

@export var name: String
@export var damage: int
@export_enum("Attraktiviät", "Stärke", "Coolness", "Intelligenz", "Kreativität") var type: String
@export_enum("Attraktiviät", "Stärke", "Coolness", "Intelligenz", "Kreativität") var token: String
# TODO: effect logic with probably not String but enum or int
@export var effect: String
