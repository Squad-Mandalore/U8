extends Control

# Time interval in seconds (capped by 60 times per second so the actual value is higher)
var interval: float = 0.001
# Tracks the remaining time
var timer: float = 0.0
var is_timer_active: bool = false
var progress_bar: TextureProgressBar = null
var item_hud_scene = preload("res://ui/inventory/subscenes/item_info.tscn")
var resistance_hud_scene = preload("res://ui/inventory/subscenes/resistance_info.tscn")
# TODO: create status_types_hud_scene
var status_types_hud_scene = preload("res://ui/inventory/subscenes/resistance_info.tscn")

func _ready() -> void:
    # SignalDispatcher.start_timer.connect(start_timer)
    SignalDispatcher.toggle_item_hud.connect(toggle_item_hud)
    SignalDispatcher.toggle_resistance_hud.connect(toggle_resistance_hud)
    SignalDispatcher.toggle_status_types_hud.connect(toggle_status_types_hud)
    hide()

func toggle_resistance_hud(stats: StatsSpecifier):
    Utils.remove_all_children(%InfoFrame)
    if stats == null:
        stop_timer()
        hide()
        progress_bar = null
        return
    var resistance_hud = resistance_hud_scene.instantiate()
    %InfoFrame.add_child(resistance_hud)
    progress_bar = resistance_hud.get_ck3_progress_bar()
    SignalDispatcher.set_ck3_progress_bar_value.emit(progress_bar.value)
    resistance_hud.update_resistance_info(stats)
    start_timer()
    show()

func toggle_status_types_hud(stats: StatsSpecifier):
    Utils.remove_all_children(%InfoFrame)
    if stats == null:
        stop_timer()
        hide()
        progress_bar = null
        return
    var status_types_hud = status_types_hud_scene.instantiate()
    %InfoFrame.add_child(status_types_hud)
    progress_bar = status_types_hud.get_ck3_progress_bar()
    SignalDispatcher.set_ck3_progress_bar_value.emit(progress_bar.value)
    status_types_hud.update_resistance_info(stats)
    start_timer()
    show()

func toggle_item_hud(item: Item, is_shop_item: bool = false):
    Utils.remove_all_children(%InfoFrame)
    if item == null:
        stop_timer()
        hide()
        progress_bar = null
        return
    var item_hud = item_hud_scene.instantiate()
    %InfoFrame.add_child(item_hud)
    progress_bar = item_hud.get_ck3_progress_bar()
    SignalDispatcher.set_ck3_progress_bar_value.emit(progress_bar.value)
    item_hud.update_item_info(item, is_shop_item)
    start_timer()
    show()

func _process(delta: float) -> void:
    # Decrease the timer by the frame's delta time
    if is_timer_active:
        timer -= delta
        if timer <= 0.0:
            timer += interval # Reset the timer (for repetitive calls)
            _on_timer_timeout()

func _on_timer_timeout() -> void:
    if progress_bar.value == progress_bar.max_value:
        progress_bar.texture_progress = null
        SignalDispatcher.set_ck3_progress_bar_value.emit(progress_bar.value)
        stop_timer()
        return

    progress_bar.value += 1

func start_timer(new_interval: float = -1.0) -> void:
    if new_interval > 0.0:
        interval = new_interval
    timer = interval
    is_timer_active = true

# Stop the timer
func stop_timer() -> void:
    is_timer_active = false
