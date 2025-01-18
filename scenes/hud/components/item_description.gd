extends Control

# Time interval in seconds
var interval: float = 0.001
# Tracks the remaining time
var timer: float = 0.0
var is_timer_active: bool = false

func _ready() -> void:
    hide()
    SignalDispatcher.update_item_hud.connect(update_component)

func _process(delta: float) -> void:
    # Decrease the timer by the frame's delta time
    if is_timer_active:
            timer -= delta
            if timer <= 0.0:
                timer += interval # Reset the timer (for repetitive calls)
                _on_timer_timeout()

func update_component(item: Item):
    if item == null:
        hide()
        return
    show()
    %Ck3ProgressBar.value = 0
    SignalDispatcher.set_ck3_progress_bar_value.emit(%Ck3ProgressBar.value)
    start_timer()
    set_item_name(item)
    set_item_description(item)

func set_item_name(item: Item):
    (%ItemNameLabel as Label).text = item.name

func set_item_description(item: Item):
    (%ItemDescriptionLabel as RichTextLabel).text = item.description

func _on_timer_timeout() -> void:
    if %Ck3ProgressBar.value == %Ck3ProgressBar.max_value:
        SignalDispatcher.set_ck3_progress_bar_value.emit(%Ck3ProgressBar.value)
        stop_timer()
        return

    %Ck3ProgressBar.value += 1

func start_timer(new_interval: float = -1.0) -> void:
    if new_interval > 0.0:
        interval = new_interval
    timer = interval
    is_timer_active = true

# Stop the timer
func stop_timer() -> void:
    is_timer_active = false
