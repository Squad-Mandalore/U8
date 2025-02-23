extends Enemy

var dishonest_brothers_quest: QuestEntry = Questomania.quest_dict[DishonestBrothersQuest.NAME]

const CHRIS_ROBBERY_ID = 1
const ANDREAS_REMEMBERS_ID = 2
const ANDREAS_ROBBERY_ID = 3

# TODO: In the dialogue file replace [if false] with something like [if Questomania.quest_dict[StreikQuest.NAME].is_active()] if StreikQuest gets implemented
var dialogue = preload("res://characters/npcs/andreas/assets/andreas_robbery.dialogue")
var _picked_a_fight: bool = false

func _enter_tree() -> void:
    if not dishonest_brothers_quest.get_subquest(CHRIS_ROBBERY_ID).is_completed() or SourceOfTruth.chance(40):
        queue_free()
        return

func set_player_nearby(is_player_nearby : Player):
    _player_nearby = is_player_nearby
    if not _player_nearby:
        return

    if dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).is_active():
        _picked_a_fight = true
        start_combat()
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
    dishonest_brothers_quest.get_subquest(CHRIS_ROBBERY_ID).set_completed(true)
    stop_talking()
    _player_nearby._stop_talking(self)
    start_combat()

func _robbing(percent: float):
    var money = floor(SourceOfTruth.balance * percent)
    print("Andreas stole %d Euronen" % money)
    SourceOfTruth.balance_changed(-money)
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_completed(true)
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_active(false)
    dishonest_brothers_quest.set_completed(true)

func _impressing():
    # TODO: sonnenbrille geben
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_completed(true)
    dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_active(false)
    dishonest_brothers_quest.set_completed(true)

func start_combat():
    if !_picked_a_fight:
        return

    super.start_combat()

func _let_robbing_happen():
    dishonest_brothers_quest.set_meta("red", true)
    _robbing(0.3)

func fight_lost():
    super.fight_lost()

    const WINNING_MONEY = 10
    print("Player won %d Euronen" % WINNING_MONEY)
    SourceOfTruth.balance_changed(WINNING_MONEY)
    if dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).is_active():
        dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).set_completed(true)
        dishonest_brothers_quest.get_subquest(ANDREAS_REMEMBERS_ID).set_active(false)
    else:
        dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_completed(true)
        dishonest_brothers_quest.get_subquest(ANDREAS_ROBBERY_ID).set_active(false)
    dishonest_brothers_quest.set_completed(true)
