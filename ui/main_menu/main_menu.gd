extends MainMenu

@onready var sub_title_label: Control = %SubTitleLabel
var sub_title_text : Array[String] = [
    "Der realistischste Berliner U-Bahn Simulator",
    "Die wahre Berlin experience",
    "Scoot Scoot",
    "Hier gilt Rauchverbot! Vielen Dank!",
]
const SEPERATOR: String = "             "

func _ready() -> void:
    super._ready()
    sub_title_text.shuffle()
    sub_title_label.text = SEPERATOR.join(sub_title_text)

func load_game_scene():
    GameState.start_game()
    super.load_game_scene()

func new_game():
    GlobalState.reset()
    load_game_scene()

func _setup_game_buttons():
    super._setup_game_buttons()
    if GameState.has_game_state():
        %ContinueGameButton.disabled = false
