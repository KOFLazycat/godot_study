extends Node

var main_scene: PackedScene = preload("res://src/main/scene/ui/main.tscn")

const GROUP_CUP: String = "cup"
const GROUP_ANIMAL: String = "animal"


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
