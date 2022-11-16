extends state

func enter_state(_state_machine):
	super.enter_state(_state_machine)
	print("进入state_1")
	state_machine.root.get_node("Label").text = "enter_state_1"
	pass

func exit_state():
	print("退出state_1")

func process(delta):
	pass
	
func physics_process(delta):
	pass
