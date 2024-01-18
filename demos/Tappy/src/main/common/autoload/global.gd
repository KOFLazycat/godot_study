extends Node

var game_scene: PackedScene = preload("res://src/main/scene/game/game.tscn")
var main_scene: PackedScene = preload("res://src/main/scene/ui/main.tscn")

signal game_over
signal score_update

const GROUP_PLANE: String = "plane"

var _score: int = 0
var _high_score: int = 0


func load_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)


func get_score() -> int:
	return _score


func set_score(v: int) -> void:
	_score = v
	if _score > _high_score:
		_high_score = _score


func increment_score() -> void:
	set_score(_score + 1)
	score_update.emit()


func get_high_score() -> int:
	return _high_score
