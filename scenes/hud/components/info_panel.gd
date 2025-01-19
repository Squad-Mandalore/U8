extends Control

# Time interval in seconds (capped by 60 times per second so the actual value is higher)
var interval: float = 0.001
# Tracks the remaining time
var timer: float = 0.0
var is_timer_active: bool = false
var progress_bar: TextureProgressBar = null
var item_hud_scene = preload("res://scenes/hud/components/item_description.tscn")

func _ready() -> void:
    SignalDispatcher.start_timer.connect(start_timer)
    SignalDispatcher.toggle_item_hud.connect(toggle_item_hud)
    hide()

func remove_all_children(parent: Node):
    for child in parent.get_children():
        child.queue_free()

func toggle_item_hud(item: Item):
    remove_all_children(%InfoFrame)
    if item == null:
        stop_timer()
        hide()
        progress_bar = null
        return
    var item_hud = item_hud_scene.instantiate()
    %InfoFrame.add_child(item_hud)
    progress_bar = item_hud.get_ck3_progress_bar()
    item_hud.update_component(item)
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
        progress_bar.texture_progress = load("res://assets/hud/ck_3_bar_close.svg")
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
