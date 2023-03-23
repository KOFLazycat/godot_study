extends Node2D


var speed = 0
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta
	if position.x <= 100:
		position.x = 1800
		speed = randi_range(100, 800)
		score += 10
		print(score)
