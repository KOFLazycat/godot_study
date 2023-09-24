class_name StateMachine
extends Node

var current_state: int = -1:
	set(v):
		owner.transition_state(current_state, v)
		current_state = v


func _ready() -> void:
	await owner.ready
	current_state = 0


func _physics_process(delta: float) -> void:
	while true:
		var next := owner.get_next_state(current_state) as int
		if current_state == next:
			break
		current_state = next
	
	owner.tick_physics(delta, current_state)
