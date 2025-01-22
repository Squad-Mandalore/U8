class_name RunState
extends Resource

@export var stats: StatsSpecifier

@export var inventory_slots: Array[Item]

func _init():
    stats = preload("res://characters/player/classes/honest_burgy.tres")

    inventory_slots.resize(16)
    inventory_slots.fill(null)
