extends Station

@onready var berlin_bear = %BerlinBear

func _on_boss_area_body_exited(_body: Node2D) -> void:
    berlin_bear.start_combat()
    $BossArea.queue_free()
