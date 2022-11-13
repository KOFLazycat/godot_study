extends StaticBody2D

var mouseEntered:bool = false
var is_selected:bool = false
@onready var selected = $Selected


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	selected.visible = is_selected


func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			is_selected = !is_selected
			if is_selected:
				Game.spawnUnit(position)


func _on_mouse_entered():
	mouseEntered = true


func _on_mouse_exited():
	mouseEntered = false
