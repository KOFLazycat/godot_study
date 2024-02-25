class_name StateMachine
extends Node

const KEEP_CURRENT: int = -1

var current_state: int = -1:
	set(v):
		# 状态切换
		owner.transition_state(current_state, v)
		# 设置当前状态
		current_state = v
		# 重置状态持续时间
		state_time = 0

var state_time: float


func _ready() -> void:
	await owner.ready
	current_state = 0


func _physics_process(delta: float) -> void:
	while true:
		var next: int = owner.get_next_state(current_state) as int
		if next == KEEP_CURRENT:
			break
		current_state = next
	
	owner.tick_physics(delta, current_state)
	state_time += delta
