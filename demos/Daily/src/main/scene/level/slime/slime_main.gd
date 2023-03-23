extends Node2D

@onready var cover = $Cover
@onready var game_over = $GameOver
@onready var slime_player = $SlimePlayer
@onready var triangle = $Triangle
@onready var triangle_2 = $Triangle2
@onready var score_label = $ScoreLabel
@onready var bg_music = $BgMusic


var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	slime_player.position = Vector2(200, 580)
	triangle.position = Vector2(3000, 200)
	triangle_2.position = Vector2(1500, 580)
	score_label.text = "Score: " + str(score)
	slime_player.hide()
	game_over.hide()
	cover.show()
	score_label.position = Vector2(400, 70)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score = triangle.score + triangle_2.score
	score_label.text = "Score: " + str(score)


func _on_play_btn_game_start():
	cover.hide()
	slime_player.show()
	triangle.speed = 100
	triangle_2.speed = 200
	


func _on_slime_player_game_over():
	triangle.speed = 0
	triangle_2.speed = 0
	game_over.show()
	score_label.position = Vector2(400, 400)
	score_label.text = "Your Score: " + str(score)
	get_tree().paused = true


func _on_bg_music_finished():
	bg_music.play()
