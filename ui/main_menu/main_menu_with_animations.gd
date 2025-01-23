extends MainMenu

var animation_state_machine : AnimationNodeStateMachinePlayback
@onready var sub_title_label: Label = $MenuContainer/SubTitleMargin/SubTitleContainer/SubTitleLabel
var SUB_TITLE_TEXTS : Array[String] = ["Der realistischste Berliner U-Bahn Simulator", "Die wahre Berlin experience", "Scoot Scoot", "Subtitle"]


func load_game_scene():
    GameState.start_game()
    super.load_game_scene()

func new_game():
    GlobalState.reset()
    load_game_scene()

func intro_done():
    animation_state_machine.travel("OpenMainMenu")

func _is_in_intro():
    return animation_state_machine.get_current_node() == "Intro"

func _event_is_mouse_button_released(event : InputEvent):
    return event is InputEventMouseButton and not event.is_pressed()

func _event_skips_intro(event : InputEvent):
    return event.is_action_released("ui_accept") or \
        event.is_action_released("ui_select") or \
        event.is_action_released("ui_cancel") or \
        _event_is_mouse_button_released(event)

func _open_sub_menu(menu):
    super._open_sub_menu(menu)
    animation_state_machine.travel("OpenSubMenu")

func _close_sub_menu():
    super._close_sub_menu()
    animation_state_machine.travel("OpenMainMenu")

func _input(event):
    if _is_in_intro() and _event_skips_intro(event):
        intro_done()
        return
    super._input(event)

func _ready():
    super._ready()
    fick_godot()
    sub_title_label.text = SUB_TITLE_TEXTS[randi_range(0, SUB_TITLE_TEXTS.size() - 1)]
    animation_state_machine = $MenuAnimationTree.get("parameters/playback")

func fick_godot() -> void:
    SignalDispatcher.sound_music.emit("main_menu")


func _setup_game_buttons():
    super._setup_game_buttons()
    if GameState.has_game_state():
        %ContinueGameButton.show()

func _on_continue_game_button_pressed():
    load_game_scene()
