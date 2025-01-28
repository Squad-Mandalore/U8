extends Node

var quest_manager: QuestManager = QuestManager.new()
const SAVE_PATH : String = "user://quests.cfg"
var quest_dict: Dictionary = {}
var config_file : ConfigFile = ConfigFile.new()

var tautology : Callable = func tautology() -> bool:
    return true

var contradiction : Callable = func contradiction() -> bool:
    return false

func _ready() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        # Create logic to create all quests
        var dishonest_brothers_quest: QuestEntry = (
            quest_manager
            .add_quest(DishonestBrothersQuest.NAME, DishonestBrothersQuest.DESCRIPTION)
        )
        quest_dict[DishonestBrothersQuest.NAME] = dishonest_brothers_quest
        DishonestBrothersQuest.nnew(dishonest_brothers_quest)
    else:
        var _load_success : Error = config_file.load(SAVE_PATH)
        var data : Array[Dictionary] = config_file.get_value("quest_manager", "data")
        quest_manager.set_data(data)
        var quest_id : int = config_file.get_value("quest_manager", DishonestBrothersQuest.NAME)
        quest_dict[DishonestBrothersQuest.NAME] = quest_manager.get_quest(quest_id)

    # WARNING: On an actual project you might want to clear the quest conditions before saving the quest to disk and reinstall those conditions at runtime after loading the data from disk.
    # quest_manager.clear_conditions() can also be called to clear the conditions of all the quests before saving its data.
    DishonestBrothersQuest.connect_conditions()

    # The order in which each quest is added is important.
    # Tracking each quest entry ID is useful when mid-development the order in which the quests are created changes.
    for quest in quest_dict:
        config_file.set_value("quest_manager", quest, quest_dict[quest].get_id())

func save():
    quest_manager.clear_conditions()
    config_file.set_value("quest_manager","data", quest_manager.get_data())
    var _save_success : Error = config_file.save(SAVE_PATH)

func get_subquests(quest_entr: QuestEntry):
    var arrr: Array[QuestEntry]
    for id in quest_entr.get_subquests_ids():
        arrr.push_back(quest_entr.get_subquest(id))

    return arrr

