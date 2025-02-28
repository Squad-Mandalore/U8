extends Enemy

var dishonest_brothers_quest: QuestEntry = Questomania.quest_dict[DishonestBrothersQuest.NAME]
var sun_glassses: Item = preload("res://items/armor/sun_glasses.tres")

const CHRIS_ROBBERY_ID = 1
const ANDREAS_REMEMBERS_ID = 2
const ANDREAS_ROBBERY_ID = 3
var _chris_robbery_quest: QuestEntry = dishonest_brothers_quest.get_subquest(CHRIS_ROBBERY_ID)
var _andreas_remembers_quest: QuestEntry = dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID)
var _andreas_robbery_quest: QuestEntry = dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID)

# TODO: In the dialogue file replace [if false] with something like [if Questomania.quest_dict[StreikQuest.NAME].is_active()] if StreikQuest gets implemented
var dialogue = preload("res://characters/npcs/andreas/assets/andreas_robbery.dialogue")

func _ready() -> void:
    if not _chris_robbery_quest.is_completed() or SourceOfTruth.chance(40):
        queue_free()
        return

    super._ready()

func set_player_nearby(is_player_nearby : Player):
    super.set_player_nearby(is_player_nearby)
    if not _player_nearby or not dishonest_brothers_quest.is_active():
        return

    if _andreas_remembers_quest.is_active():
        start_talking()
        _player_nearby._start_scripted_talking(self)
        DialogueManager.show_dialogue_balloon(dialogue, "remembers", [self])
        DialogueManager.dialogue_ended.connect(_dialogue_ended)
    else:
        start_robbing()


func start_robbing():
    if SourceOfTruth.stats.intelligence < 12:
        if dishonest_brothers_quest.get_metadata("green", false):
            _robbing(0.15)
        else:
            _robbing(0.3)
    else:
        start_talking()
        _player_nearby._start_scripted_talking(self)
        DialogueManager.show_dialogue_balloon(dialogue, "start", [self])
        DialogueManager.dialogue_ended.connect(_dialogue_ended)

func _dialogue_ended(_resource):
    DialogueManager.dialogue_ended.disconnect(_dialogue_ended)
    stop_talking()
    _player_nearby._stop_talking(self)

func _robbing(percent: float):
    var money = floor(SourceOfTruth.balance * percent)
    print("Andreas stole %d Euronen" % money)
    SourceOfTruth.balance_changed(-money)
    _quest_robbery_complete()

func _impressing():
    SourceOfTruth.add_item(sun_glassses)
    _quest_robbery_complete()


func _let_robbing_happen():
    dishonest_brothers_quest.set_metadata("red", true)
    _robbing(0.3)

func fight_lost(calculate_money: Callable = _calculate_win):
    super.fight_lost(calculate_money)
    if _andreas_remembers_quest.is_active():
        _quest_remembers_complete()
    else:
        _quest_robbery_complete()

func _quest_robbery_complete():
    _andreas_robbery_quest.set_active(false)
    _andreas_robbery_quest.set_completed(true)
    _quest_dishones_brothers_complete()

func _quest_remembers_complete():
    _andreas_remembers_quest.set_active(false)
    _andreas_remembers_quest.set_completed(true)
    _quest_dishones_brothers_complete()

func _quest_dishones_brothers_complete():
    dishonest_brothers_quest.set_active(false)
    dishonest_brothers_quest.set_completed(true)

