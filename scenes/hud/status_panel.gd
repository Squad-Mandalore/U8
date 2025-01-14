extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_health(new_health: int) -> void:
    var max_health: int = 100
    new_health = min(new_health, max_health)
    (%HealthBar as TextureProgressBar).max_value = max_health
    (%CurFromMaxHealthLabel as Label).text = "%d/%d" % [new_health, max_health]
    (%HealthBar as TextureProgressBar).value = new_health

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
