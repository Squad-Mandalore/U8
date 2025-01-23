class_name RunState
extends Resource

@export var stats: Class

@export var inventory_slots: Array[Item]

func _init():
    stats = preload("res://characters/classes/assets/honest_burgy.tres").duplicate()

    inventory_slots.resize(16)
    inventory_slots.fill(null)
