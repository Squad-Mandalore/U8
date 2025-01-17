extends MainMenu

@onready var sub_title_label: Label = $MenuContainer/SubTitleMargin/SubTitleContainer/SubTitleLabel
var SUB_TITLE_TEXTS : Array[String] = ["Der realistischste Berliner U-Bahn Simulator", "Die wahre Berlin experience", "Scoot Scoot"]

func _ready() -> void:
    super._ready()
    sub_title_label.text = SUB_TITLE_TEXTS[randi_range(0, SUB_TITLE_TEXTS.size() - 1)]
