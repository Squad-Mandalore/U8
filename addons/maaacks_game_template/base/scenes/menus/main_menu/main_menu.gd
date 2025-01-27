class_name MainMenu
extends Control

## Defines the path to the game scene. Hides the play button if empty.
@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene

var options_scene
var credits_scene
var sub_menu

func load_game_scene():
    SceneLoader.load_scene(game_scene_path)

func new_game():
    load_game_scene()

func _open_sub_menu(menu : Control):
    sub_menu = menu
    sub_menu.show()
    %BackButton.show()
    %MenuContainer.hide()

func _close_sub_menu():
    if sub_menu == null:
        return
    sub_menu.hide()
    sub_menu = null
    %BackButton.hide()
    %MenuContainer.show()

func _event_is_mouse_button_released(event : InputEvent):
    return event is InputEventMouseButton and not event.is_pressed()

func _input(event):
    if event.is_action_released("ui_cancel"):
        if sub_menu:
            _close_sub_menu()
        else:
            get_tree().quit()
    if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
        %MenuButtonsBoxContainer.focus_first()

func _setup_for_web():
    if OS.has_feature("web"):
        %ExitButton.hide()

func _setup_game_buttons():
    if game_scene_path.is_empty():
        %NewGameButton.disabled = true

func _setup_options():
    if options_packed_scene == null:
        %OptionsButton.hide()
    else:
        options_scene = options_packed_scene.instantiate()
        options_scene.hide()
        %OptionsContainer.call_deferred("add_child", options_scene)

func _setup_credits():
    if credits_packed_scene == null:
        %CreditsButton.hide()
    else:
        credits_scene = credits_packed_scene.instantiate()
        credits_scene.hide()
        if credits_scene.has_signal("end_reached"):
            credits_scene.connect("end_reached", _on_credits_end_reached)
        %CreditsContainer.call_deferred("add_child", credits_scene)

func _ready():
    _setup_for_web()
    _setup_options()
    _setup_credits()
    _setup_game_buttons()

func _on_new_game_button_pressed():
    new_game()

func _on_options_button_pressed():
    _open_sub_menu(options_scene)

func _on_credits_button_pressed():
    _open_sub_menu(credits_scene)
    credits_scene.reset()

func _on_exit_button_pressed():
    get_tree().quit()

func _on_credits_end_reached():
    if sub_menu == credits_scene:
        _close_sub_menu()

func _on_back_button_pressed():
    _close_sub_menu()

func _on_continue_game_button_pressed():
    load_game_scene()
