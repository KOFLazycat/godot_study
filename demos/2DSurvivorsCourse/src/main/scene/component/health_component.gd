class_name HealthComponent
extends Node

@export var max_health: float = 10
var current_health: float

signal die

func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float) -> void:
	current_health = max(current_health - damage_amount, 0)
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0:
		die.emit()
		owner.queue_free()
