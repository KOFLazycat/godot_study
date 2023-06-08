extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_game_state()
	get_tree().paused = false
	var child_scene: PackedScene = null
	if Global.difficulty == Global.Difficulty.HARD:
#		child_scene = load("res://interior/hard_mode.tscn")
		pass
	else:
		child_scene = load("res://src/main/scene/level/normal/normal_model.tscn")
		pass
	add_child( child_scene.instantiate() )

