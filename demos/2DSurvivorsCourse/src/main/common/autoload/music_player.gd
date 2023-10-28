extends AudioStreamPlayer
# 背景音樂播放完畢後會有15秒左右的間隔
@onready var timer: Timer = $Timer


func _ready() -> void:
	finished.connect(on_finished)
	timer.timeout.connect(on_timer_timeout)


func on_finished() -> void:
	timer.start()


func on_timer_timeout() -> void:
	play()
