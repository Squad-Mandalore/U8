class_name DishonestBrothersQuest
extends Node

const NAME: String = "Dishonest Brothers"
const DESCRIPTION: String = "Offen Unehrlich"

# this function adds subquests
static func nnew(dishonest_brothers_quest: QuestEntry):
    dishonest_brothers_quest.add_subquest("chris_robbery")
    dishonest_brothers_quest.add_subquest("andreas_remembers")
    dishonest_brothers_quest.add_subquest("andreas_robbery")

static func connect_conditions():
    var dishonest_brothers_quest = Questomania.quest_dict[NAME]
    for subquest: QuestEntry in Questomania.get_subquests(dishonest_brothers_quest):
        match subquest.get_title():
            "chris_robbery":
                _chris_robbery(subquest)
            "andreas_remembers":
                _andreas_remembers(subquest)
            "andreas_robbery":
                _andreas_robbery(subquest)
            _:
                printerr("No quest with Title: ", subquest.get_title())


static func _chris_robbery(quest: QuestEntry):
    pass

static func _andreas_remembers(quest: QuestEntry):
    pass

static func _andreas_robbery(quest: QuestEntry):
    pass
