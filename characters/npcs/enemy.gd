extends Npc
class_name Enemy

@export var attacks: Array[Attack]
@export var albedo_texture: AtlasTexture
@export var combat_animation: String = "battle_idle"
@export var stats: StatsSpecifier


func _ready() -> void:
    super._ready()
    # Enemy needs duplicated attacks otherwise it could interfere with the players attacks
    for i in range(len(attacks)):
        attacks[i] = attacks[i].duplicate()
        attacks[i].calculate_damage(stats)

func start_combat():
    SignalDispatcher.combat_enter.emit(self)
