class_name World
extends Node2D

@export var bgm: AudioStream

@onready var tile_map: TileMap = $TileMap
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var player: Player = $Player
@onready var boar: CharacterBody2D = $Boar
@onready var boar_2: CharacterBody2D = $Boar2


func _ready() -> void:
	# 野猪死亡 马上通关
	boar.died.connect(on_boar_died)
	var used := tile_map.get_used_rect().grow(-1)
	var tile_size := tile_map.tile_set.tile_size
	
	camera_2d.limit_top = used.position.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_right = used.end.x * tile_size.x
	camera_2d.reset_smoothing()
	
	if bgm:
		SoundManager.play_bgm(bgm)


func update_player(pos: Vector2, direction: Player.Direction) -> void:
	player.global_position = pos
	player.fall_from_y = pos.y
	player.direction = direction
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()


func to_dict() -> Dictionary:
	var enemies_alive: Array[String] = []
	
	for node in get_tree().get_nodes_in_group("enemies"):
		var path: String = get_path_to(node) as String
		if not path.is_empty():
			enemies_alive.append(path)
	
	return {
		"enemies_alive": enemies_alive,
	}


func from_dict(dict: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("enemies"):
		var path: String = get_path_to(node) as String
		if not path.is_empty() and path not in dict.enemies_alive:
			node.queue_free()


func on_boar_died() -> void:
	await get_tree().create_timer(1).timeout
	Game.change_scene("res://src/main/scene/ui/game_end_screen.tscn", {
		"duration": 1,
	})

