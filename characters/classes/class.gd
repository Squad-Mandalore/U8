class_name Class
extends StatsSpecifier

@export var name: String
@export var attacks: Array[Attack]

func _to_string() -> String:
    return """Attack Details:
    Name: %s
    Attacks: %s
    """ % [name, str(attacks)]
