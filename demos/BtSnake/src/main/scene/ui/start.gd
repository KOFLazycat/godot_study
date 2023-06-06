extends ColorRect


func _on_button_normal_pressed() -> void:
	Global.difficulty = Global.Difficulty.NORMAL
	get_tree().change_scene_to_file("res://src/main/scene/ui/room.tscn")


func _on_button_hard_pressed() -> void:
	Global.difficulty = Global.Difficulty.HARD
	get_tree().change_scene_to_file("res://src/main/scene/ui/room.tscn")
