extends Station

@onready var lifeguard = %Lifeguard

func _on_boss_area_body_exited(_body: Node2D) -> void:
    lifeguard.start_combat()
    $BossArea.queue_free()
