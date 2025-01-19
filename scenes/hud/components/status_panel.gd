extends Control

func _ready() -> void:
    SignalDispatcher.stats_changed.connect(update_status_panel)

func update_status_panel(stats: StatsSpecifier, balance: int):
    update_health(stats.health, stats.max_health)
    update_balance(balance)
    # TODO: status types
    # update_blood(stats.)
    # update_flask(stats.)
    # update_syringe(stats.)

func update_health(new_health: int, max_health: int) -> void:
    new_health = min(new_health, max_health)
    %HealthBar.set_max_value(max_health)
    %HealthBar.set_stat_name("Gesundheit")
    %HealthBar.set_stat_number("%d/%d" % [new_health, max_health])
    %HealthBar.set_cur_value(new_health)

func update_balance(new_balance: int) -> void:
    var min_balance: int
    new_balance = max(min_balance, new_balance)
    (%BalanceLabel as Label).text = "%d Euronen" % [new_balance]

func update_blood(toggle: bool) -> void:
    (%BloodTexture as TextureRect).visible = toggle

func update_flask(toggle: bool) -> void:
    (%FlaskTexture as TextureRect).visible = toggle

func update_syringe(toggle: bool) -> void:
    (%SyringeTexture as TextureRect).visible = toggle
