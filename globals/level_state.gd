class_name RunState
extends Resource

@export var stats: StatsSpecifier

@export var balance: int

@export var inventory_slots: Array[Item]
@export var cur_inventory_size: int
@export var max_inventory_size: int

func _init():
    balance = 0
    cur_inventory_size = 4
    max_inventory_size = 16

    stats = preload("res://characters/player/classes/honest_burgy.tres")
    stats.bleed_level = 0
    stats.drug_level = 0
    stats.poison_level = 0

    inventory_slots.resize(max_inventory_size)
    inventory_slots.fill(null)
