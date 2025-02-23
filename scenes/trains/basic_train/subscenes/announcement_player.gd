extends AudioStreamPlayer
@export var _basic_announcement : AudioStreamWAV
@export var _announcment_announcer : AudioStreamWAV
@export var _announcement : Array[AudioStreamWAV]
var _current_station : int = 0

func _ready():
    _current_station = GameState.get_current_station()
    self.stream = _basic_announcement
    call_deferred("_start_announcement")

func _start_announcement():
    await get_tree().create_timer(2.0).timeout
    self.play()


func _on_finished():
    match self.stream:
        _basic_announcement:
            self.stream = _announcment_announcer
            self.play()
        _announcment_announcer:
            self.stream = _announcement[_current_station]
            self.play()
