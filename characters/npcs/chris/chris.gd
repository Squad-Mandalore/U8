extends Npc

@onready var dishonest_brothers_quest: QuestEntry = Questomania.quest_dict[DishonestBrothersQuest.NAME]

func set_player_nearby(is_player_nearby : Player):
    _player_nearby = is_player_nearby
    if _player_nearby and not dishonest_brothers_quest.is_active():
        start_robbing()


func start_robbing():
    dishonest_brothers_quest.set_active(true)
    var robbery = dishonest_brothers_quest.get_subquest(1)
    if SourceOfTruth.stats.intelligence < 6:
        var money = floor(SourceOfTruth.balance * 0.1)
        print("Chris stole %d Euronen" % money)
        SourceOfTruth.balance_changed(-money)
        robbery.set_completed(true)
        dishonest_brothers_quest.get_subquest(3).set_accepted(true)
    else:
        super.start_talking()
        _player_nearby._start_scripted_talking(self)
