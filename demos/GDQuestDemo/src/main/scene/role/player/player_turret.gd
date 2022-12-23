extends Node2D

@onready var shoot_position = $ShootPosition
const arrow_scene = preload("res://src/main/scene/role/arrow/arrow.tscn")
const fire_ball_scene = preload("res://src/main/scene/role/fire_ball/fire_ball.tscn")


func _physics_process(delta):
	look_at(get_global_mouse_position())


func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		shoot(arrow_scene)
	elif event.is_action_pressed("right_click"):
		shoot(fire_ball_scene)


func shoot(projectile: PackedScene):
	var bullet := projectile.instantiate()
	bullet.position = shoot_position.global_position
	bullet.direction = global_position.direction_to(get_global_mouse_position())
	add_child(bullet)
