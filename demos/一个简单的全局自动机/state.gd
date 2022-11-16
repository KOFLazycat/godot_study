extends Node2D

# 抽象状态
class_name state

# 状态机
var state_machine

# 进入状态
func enter_state(_state_machine):
	state_machine = _state_machine
	pass

# 离开状态
func exit_state():
	pass

# 状态自定义process
func process(delta):
	pass

# 状态自定义physics_process
func physics_process(delta):
	pass
