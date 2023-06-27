extends Node2D


@onready var timer: Timer = $Timer
@onready var path_level_test_tscn = preload("res://src/main/scene/level/level_test/path_level_test.tscn")
@export var interval_time : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(interval_time)


func _on_timer_timeout() -> void:
	var path_level_test = path_level_test_tscn.instantiate()
	add_child(path_level_test)
