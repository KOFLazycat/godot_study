extends Node
class_name HealthSystem

@export var max_health: float = 1

var health: float:
	set(v):
		# 限制health范围
		health = clampf(v, 0, max_health)


func _ready() -> void:
	health = max_health
