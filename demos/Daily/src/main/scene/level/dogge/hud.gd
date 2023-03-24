extends Node2D

@onready var timer = $Timer
@onready var score_label = $ScoreLabel
@onready var info_label = $InfoLabel
@onready var start_button = $StartButton

signal game_start
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	emit_signal("game_start")
	timer.start(1)


func _on_timer_timeout():
	score += 1
	score_label.text = str(score)
