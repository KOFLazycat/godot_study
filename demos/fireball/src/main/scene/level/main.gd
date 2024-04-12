extends Node2D

@export var fire_ball_scene: PackedScene = preload("res://src/main/scene/fire_ball/FireBall.tscn")

@onready var player: Sprite2D = $Player


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var fire_ball: FireBall = fire_ball_scene.instantiate()
		add_child(fire_ball)
		fire_ball.global_position = player.global_position
		fire_ball.target_global_position = get_global_mouse_position()
