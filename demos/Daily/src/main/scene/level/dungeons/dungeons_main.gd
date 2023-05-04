extends Node2D


func _on_button_start_pressed() -> void:
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/dungeons/level_first.tscn")
	assert(err == OK)


func _on_button_end_pressed() -> void:
	get_tree().quit()
