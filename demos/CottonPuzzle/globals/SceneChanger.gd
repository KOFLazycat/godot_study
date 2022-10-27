extends Node
@onready var animation_player = $AnimationPlayer

func change_scene(path: String):
	animation_player.play("fade-in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
