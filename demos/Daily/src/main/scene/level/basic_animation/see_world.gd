extends Node2D

@onready var bird = $Bird
@onready var bg = $Bg

var move_speed = 1
var n = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bird.play("fly")
	bird.position.x += move_speed
	if bird.position.x > 1000 :
		bird.position.x = -100
		n += 1
		if n == 2:
			n = 0
		bg.frame = n
