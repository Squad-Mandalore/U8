class_name RunState
extends Resource

@export var stats: Class

@export var inventory_slots: Array[Item]

func _init():
    stats = preload("res://characters/classes/assets/honest_burgy.tres").duplicate()

    inventory_slots.resize(16)
    inventory_slots.fill(null)

static func get_run_state() -> RunState:
    return GameState.get_run_state()

static func get_inventory_slots() -> Array[Item]:
    var run_state = get_run_state()
    if not run_state.inventory_slots:
        var inv: Array[Item] = []
        inv.resize(16)
        inv.fill(null)
        return inv
    return run_state.inventory_slots

static func get_stats() -> Class:
    var run_state = get_run_state()
    if not run_state.stats:
        return preload("res://characters/classes/assets/honest_burgy.tres").duplicate()
    return run_state.stats

static func set_inventory_slots(inv: Array[Item]):
    var run_state = get_run_state()
    if not run_state:
        return
    run_state.inventory_slots = inv

static func set_stats(stats: Class):
    var run_state = get_run_state()
    if not run_state:
        return
    run_state.stats = stats
