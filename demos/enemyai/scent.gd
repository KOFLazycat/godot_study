extends Node2D
class_name Scent # 气味类

@onready var timer: Timer = $Timer

var player: Player


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout() -> void:
	player.scent_array.erase(self)
	queue_free()
