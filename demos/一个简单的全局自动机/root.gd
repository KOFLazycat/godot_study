extends Sprite2D


@onready var state_machine = $state_machine



func _on_button_1_pressed():
	state_machine.enter_state("state_1")
	pass # Replace with function body.


func _on_button_2_pressed():
	state_machine.enter_state("state_2")
	pass # Replace with function body.
