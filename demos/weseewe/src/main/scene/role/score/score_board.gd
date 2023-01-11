extends Node2D


@onready var best_round = $Msg/Panel/HBoxContainer/Score/BestRound
@onready var last_round = $Msg/Panel/HBoxContainer/Score/LastRound
@onready var rounds_played = $Msg/Panel/HBoxContainer/Score/RoundsPlayed
@onready var avg_per_round = $Msg/Panel/HBoxContainer/Score/AvgPerRound
@onready var colors_earned = $Msg/Panel/HBoxContainer/Score/ColorsEarned


func _ready():
	setScore()


#设置分数
func setScore():
	best_round.text=str(Game.data['best_round'])
	last_round.text=str(Game.data['last_round'])
	rounds_played.text=str(Game.data['rounds_played'])
	avg_per_round.text=str(snappedf(Game.data['avg_per_round'],0.01))
	colors_earned.text=str(Game.data['colors_earned'])


func _process(delta):
	queue_redraw()
	
func _draw():
	draw_line(Vector2(120,0),Vector2(120,$Msg.position.y-130),Game.lineColor[0],0.5,true)
	draw_line(Vector2(200,0),Vector2(200,$Msg.position.y-130),Game.lineColor[0],0.5,true)


