extends Node2D

@onready var bird = $Bird
@onready var marker_2d = $Bird/Marker2D
@onready var timer = $Timer
var bullet = preload("res://src/main/scene/level/basic_animation/bullet.tscn")
var fire_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	bird.frame = 0
	timer.start(0.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("space"):
		fire_flag = !fire_flag
	if fire_flag:
		bird.frame = 1
	else:
		bird.frame = 0


func _on_timer_timeout():
	if fire_flag:
		var bul = bullet.instantiate()
		bul.position = marker_2d.global_position
		add_child(bul)
