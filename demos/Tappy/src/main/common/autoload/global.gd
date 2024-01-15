extends Node

var game_scene: PackedScene = preload("res://src/main/scene/game/game.tscn")
var main_scene: PackedScene = preload("res://src/main/scene/ui/main.tscn")

signal game_over

func load_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
