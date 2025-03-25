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
    pass
