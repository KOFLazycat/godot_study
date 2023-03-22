extends Node2D


@onready var line_2d = $Line2D
@onready var ball = $Ball


var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	ball.position = Vector2(480, 60)
	line_2d.points = [Vector2(0, 300), Vector2(960, 300)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ball.position.y > 300:
		speed -= 18
		line_2d.points = [Vector2(0, 300), ball.position, Vector2(960, 300)]
	else:
		speed += 20
		line_2d.points = [Vector2(0, 300), Vector2(960, 300)]
	ball.position.y += speed * delta
