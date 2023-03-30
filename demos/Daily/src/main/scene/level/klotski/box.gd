extends Node2D

@onready var label_stage = $LabelStage


signal game_win
signal game_reset

# Called when the node enters the scene tree for the first time.
func _ready():
	label_stage.text = str(Global.glob_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	print(222)
	print(area)
	if area.is_in_group("red_wood"):
		emit_signal("game_win")


func _on_reset_pressed():
	emit_signal("game_reset")


func _on_next_stage_pressed():
	var err = null
	if Global.glob_level >= 3:
		Global.glob_level = 3
	else:
		Global.glob_level += 1
	match Global.glob_level:
		1:
			err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/first.tscn")
		2:
			err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/second.tscn")
		3:
			err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/third.tscn")
	if err != OK:
		print("Next Stage Loading Error...")


func _on_before_stage_pressed():
	var err = null
	if Global.glob_level <= 1:
		Global.glob_level = 1
	else:
		Global.glob_level -= 1
	match Global.glob_level:
		1:
			err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/first.tscn")
		2:
			err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/second.tscn")
		3:
			err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/third.tscn")
	if err != OK:
		print("Before Stage Loading Error...")


func _on_area_2d_2_area_entered(area):
	print(1112)
