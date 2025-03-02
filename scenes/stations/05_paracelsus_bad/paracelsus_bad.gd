extends Station

@onready var bademeister = %Bademeister2d


func _on_boss_area_body_exited(_body: Node2D) -> void:
    bademeister.start_combat()
    $BossArea.queue_free()
