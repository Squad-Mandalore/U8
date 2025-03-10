extends Npc
class_name Enemy

@export var attacks: Array[Attack]
@export var combat_animation: String = "battle_idle"
@export var stats: StatsSpecifier
@export var texture: Texture2D
@export var winning_money: int = 10
@export var battle_intro: String = "battle_intro"
var initial_stats: StatsSpecifier


func _ready() -> void:
    super._ready()
    # Enemy needs duplicated attacks otherwise it could interfere with the players attacks
    initial_stats = stats.duplicate()
    for i in range(len(attacks)):
        attacks[i] = attacks[i].duplicate(true)
    update_attack_damage()

func start_combat():
    if stats.health > 0:
        reset_stats()
        SignalDispatcher.combat_enter.emit(self)

func reset_stats():
    stats = initial_stats.duplicate()
    update_attack_damage()

func update_attack_damage():
    for attack in attacks:
        attack.calculate_damage(stats)

func fight_lost(calculate_money: Callable = _calculate_win):
    var win = calculate_money.call(winning_money)
    print("Player won %d Euronen" % win)
    SourceOfTruth.balance_changed(win)
    # queue_free()

func _calculate_win(money: int) -> int:
    return money * (1.0 + GameState.get_current_station() / 10.0)
