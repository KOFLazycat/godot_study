extends CharacterBody2D

@export var selected:bool = false
@onready var box = $Box


func _ready():
	set_selected(selected)
	
	
func set_selected(value:bool):
	box.visible = value
	#selected = value


func _on_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
