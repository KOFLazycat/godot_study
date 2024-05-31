extends Node

const LOAD_SAVE_RESOURCE_PATH: String = "user://load_save_resource.tres"
var is_load: bool = false


func save(player: CharacterBody2D) -> void:
	var load_save_resource: LoadSaveResource = LoadSaveResource.new()
	load_save_resource.player_position = player.global_position
	ResourceSaver.save(load_save_resource, LOAD_SAVE_RESOURCE_PATH)


func load(player: CharacterBody2D) -> void:
	var load_save_resource: LoadSaveResource = ResourceLoader.load(LOAD_SAVE_RESOURCE_PATH)
	player.global_position = load_save_resource.player_position
