extends Node
class_name StateMachine ## 状态机，状态管理类

## 初始状态
@export var init_state: State

# 状态字典
var states: Dictionary = {}
var current_state: State


func _ready() -> void:
	for state in get_children():
		if state is State:
			states[state.name.to_upper()] = state
			state.update_state.connect(_on_update_state)
	
	if init_state:
		init_state.enter()
	current_state = init_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_update_state(state_name: String) -> void:
	state_name = state_name.to_upper()
	if current_state and state_name == current_state.name.to_upper():
		return
	
	if current_state:
		current_state.exit()
	
	var new_state: State = states[state_name]
	
	if new_state:
		new_state.enter()
		current_state = new_state
	else :
		print("状态切换失败，未发现对应状态：" + state_name)



















