extends Station

@onready var bodybuilder = %Bodybuilder

func _on_boss_area_body_exited(_body: Node2D) -> void:
    bodybuilder.start_combat()
    $BossArea.queue_free()
