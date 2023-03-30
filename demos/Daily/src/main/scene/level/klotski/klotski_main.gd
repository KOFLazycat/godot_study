extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/first.tscn")
	if err != OK:
		print("First Stage Loading Error...")


func _on_button_end_pressed():
	get_tree().quit()
