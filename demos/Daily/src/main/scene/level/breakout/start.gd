extends Node2D

@onready var animation_player: AnimationPlayer = $Switch/AnimationPlayer
@onready var switch: Node2D = $Switch


func _on_button_pressed() -> void:
	animation_player.play("fade_in_out")
	await animation_player.animation_finished
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/breakout/breakout_main.tscn")
	assert(err == OK)
	
	animation_player.play_backwards("fade_in_out")
	await animation_player.animation_finished
