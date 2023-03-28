extends Node2D

@onready var timer = $Timer
@onready var label_score = $LabelScore
@onready var board = $Board
@onready var ball = $Ball


var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1)
	label_score.text = str(score)
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	score += 1
	label_score.text = str(score)
	if score == 1:
		var dir_init = Vector2.LEFT
		match randi()%4 :
			0:
				dir_init = Vector2.LEFT
			1:
				dir_init = Vector2.RIGHT
			2:
				dir_init = Vector2.UP
			3:
				dir_init = Vector2.DOWN
		ball.velocity = dir_init * 500


func _on_ball_hit():
	var dir = board.rotation
	ball.bounce(dir)
