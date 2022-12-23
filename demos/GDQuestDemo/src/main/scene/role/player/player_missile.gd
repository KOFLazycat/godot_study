extends Node2D


const missile_scene := preload("res://src/main/scene/role/weapon/missile.tscn")

@onready var shoot_position = $ShootPosition


var drag_factor = 0.3
var max_speed = 200


func _physics_process(_delta: float):
	look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		shoot()


func shoot():
	var missile := missile_scene.instantiate()
	missile.drag_factor = drag_factor
	missile.max_speed = max_speed
	missile.global_position = shoot_position.global_position
	missile.rotation = rotation
	add_child(missile)
