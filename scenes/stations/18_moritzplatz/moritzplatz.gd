extends Station

@onready var moritz = %Moritz

func _on_boss_area_body_exited(_body: Node2D) -> void:
    moritz.start_combat()
    $BossArea.queue_free()
