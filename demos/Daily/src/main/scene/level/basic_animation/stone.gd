extends Node2D

@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("space"):
		Global.g_speed += Global.g_speed * delta
		if Global.g_speed >= 10:
			Global.g_speed = 10
		player.speed_scale = Global.g_speed
		player.play("walk")
	else:
		Global.g_speed -= Global.g_speed * delta
		if Global.g_speed <= 1:
			Global.g_speed = 1
			player.play("idle")
		else:
			player.play("walk")
		player.speed_scale = Global.g_speed
