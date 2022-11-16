extends Node2D

@export var freeze_slow := 0.07
@export var freeze_time := 0.3


func _ready() -> void:
	EventBus.connect("enemy_hit",Callable(self,"freeze_engine"))


func freeze_engine() -> void:
	Engine.time_scale = freeze_slow
	await get_tree().create_timer(freeze_time * freeze_slow).timeout
	Engine.time_scale = 1
