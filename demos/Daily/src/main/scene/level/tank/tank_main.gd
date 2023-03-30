extends Node2D

@onready var tank = $Tank
@onready var marker_2d = $Tank/Area2D/Sprite2DBarrel/Marker2D
@onready var missle_timer = $Timer
@onready var plane = $Plane
@onready var marker_2d_up = $Plane/Sprite2D/Marker2DUp
@onready var marker_2d_down = $Plane/Sprite2D/Marker2DDown

@onready var cannonball_tscn = preload("res://src/main/scene/level/tank/cannonball.tscn")
@onready var missile_tscn = preload("res://src/main/scene/level/tank/missile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	missle_timer.start(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		var cannonball = cannonball_tscn.instantiate()
		add_child(cannonball)
		var _dir = (get_global_mouse_position() - marker_2d.global_position).normalized()
		var _pos = marker_2d.global_position
		cannonball.shoot(_dir, _pos)


func _on_timer_timeout():
	var missile_a = missile_tscn.instantiate()
	add_child(missile_a)
	missile_a.fire(tank, marker_2d_up.global_position)
	
	var missile_b = missile_tscn.instantiate()
	add_child(missile_b)
	missile_b.fire(tank, marker_2d_down.global_position)
