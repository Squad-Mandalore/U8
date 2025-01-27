class_name DishonestBrothersQuest
extends Node

const NAME: String = "Dishonest Brothers"
const DESCRIPTION: String = "Offen Unehrlich"

# this function adds subquests
static func nnew(dishonest_brothers_quest: QuestEntry):
    dishonest_brothers_quest.add_subquest("notice_robbery_chris")

static func connect_conditions():
    var dishonest_brothers_quest = Questomania.quest_dict[NAME]
    print(dishonest_brothers_quest)
    print(dishonest_brothers_quest.get_title())
    for subquest in Questomania.get_subquests(dishonest_brothers_quest):
        print(subquest.get_title())
    # var quest: QuestEntry = SourceOfTruth.quest_manager.add_quest("Dishonest Brothers")
    # var notice_robbery_chris: QuestEntry = quest.add_subquest("notice_robbery_chris")

    # quest.set_metadata("finished_once": false)

    # notice_robbery_chris.add_acceptance_condition(Utils.tautology)
	# notice_robbery_chris.add_completion_condition(contradiction)
	# notice_robbery_chris.add_rejection_condition(contradiction)
	# notice_robbery_chris.add_failure_condition(contradiction)
	# notice_robbery_chris.add_cancelation_condition(contradiction)

