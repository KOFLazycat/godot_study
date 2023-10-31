extends CanvasLayer

signal transition_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var skip_emit: bool = false

func transition() -> void:
	animation_player.play("default")
	#await transition_halfway
	await animation_player.animation_finished
	#skip_emit = true
	animation_player.play_backwards("default")
	await animation_player.animation_finished

func emit_transition_halfway():
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()


func transition_to_scene(scene_path: String) -> void:
	transition()
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
