extends Node

signal arena_difficulty_increased(arena_difficulty: int)

@export var end_screen_scene: PackedScene

@onready var timer: Timer = $Timer

const DIFFICULTY_INTERVAL: float = 5
var arena_difficulty: int = 0


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func _process(_delta: float) -> void:
	var next_time_target: float = timer.wait_time - (arena_difficulty + 1) * DIFFICULTY_INTERVAL
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func on_timer_timeout() -> void:
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle(false)
