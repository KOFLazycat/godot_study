extends Node2D

@onready var label_name = $LabelName


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/fly_cutter/fly_cutter_main.tscn")
	if err != OK:
		label_name.text = "加载错误..."
		print("Main Scene Loading Error...")
