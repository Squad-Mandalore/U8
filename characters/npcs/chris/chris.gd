extends Enemy

var dishonest_brothers_quest: QuestEntry = Questomania.quest_dict[DishonestBrothersQuest.NAME]

const CHRIS_ROBBERY_ID = 1
const ANDREAS_REMEMBERS_ID = 2
const ANDREAS_ROBBERY_ID = 3

var dialogue = preload("res://characters/npcs/chris/assets/chris_robbery.dialogue")

func _ready() -> void:
    if dishonest_brothers_quest.get_subquest(CHRIS_ROBBERY_ID).is_completed() or SourceOfTruth.chance(40):
        queue_free()

    super._ready()

func set_player_nearby(is_player_nearby : Player):
    super.set_player_nearby(is_player_nearby)
    if _player_nearby and not dishonest_brothers_quest.is_active():
        start_robbing()

func start_robbing():
    dishonest_brothers_quest.set_active(true)
    if SourceOfTruth.stats.intelligence < 6:
        _robbing()
    else:
        start_talking()
        _player_nearby._start_scripted_talking(self)
        DialogueManager.show_dialogue_balloon(dialogue, "start", [self])
        DialogueManager.dialogue_ended.connect(_dialogue_ended)

func _dialogue_ended(_resource):
    DialogueManager.dialogue_ended.disconnect(_dialogue_ended)
    dishonest_brothers_quest.get_subquest(CHRIS_ROBBERY_ID).set_completed(true)
    stop_talking()
    _player_nearby._stop_talking(self)

func _robbing():
    var money = floor(SourceOfTruth.balance * 0.1)
    print("Chris stole %d Euronen" % money)
    SourceOfTruth.balance_changed(-money)
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_active(true)
    dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).set_rejected(true)

func _impressing():
    dishonest_brothers_quest.set_metadata("green", true)
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_active(true)
    dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).set_rejected(true)

func _let_robbing_happen():
    dishonest_brothers_quest.set_metadata("magenta", true)
    _robbing()

func fight_lost(calculate_money: Callable = _calculate_win):
    super.fight_lost(calculate_money)
    dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).set_active(true)
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_rejected(true)

