extends MainMenu

@onready var sub_title_label: Control = %SubTitleLabel
var SUB_TITLE_TEXTS : Array[String] = ["Der realistischste Berliner U-Bahn Simulator", "Die wahre Berlin experience", "Scoot Scoot"]

func _ready() -> void:
    super._ready()
    sub_title_label.text = SUB_TITLE_TEXTS[randi_range(0, SUB_TITLE_TEXTS.size() - 1)]

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
