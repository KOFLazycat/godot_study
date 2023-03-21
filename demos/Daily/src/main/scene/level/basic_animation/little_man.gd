extends Node2D

@onready var player = $Area2D/Player


var speed = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left"):
		position.x -= speed
		player.flip_h = true
	if Input.is_action_pressed("right"):
		position.x += speed
		player.flip_h = false
	if position.x <= 10:
		position.x = 10
	if position.x >= 950:
		position.x = 950


func _on_area_2d_area_entered(area):
	if area.is_in_group("meteorolite"):
		Global.g_hp_value -= 5
