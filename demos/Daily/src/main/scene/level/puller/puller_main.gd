extends Node2D

@onready var label_score = $LabelScore
@onready var lottery = $Lottery
@onready var lottery_2 = $Lottery2
@onready var lottery_3 = $Lottery3
@onready var texture_button_pull_bar = $TextureButtonPullBar


var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pull_bar_pressed():
	score = 0
	label_score.text = "WIN: " + str(score)
	var tween = create_tween()
	tween.tween_property(texture_button_pull_bar,"rotation_degrees",-12, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(texture_button_pull_bar,"rotation_degrees",0, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT).set_delay(0.65)
	tween.play()
	texture_button_pull_bar.disabled = true
	Global.reset()
	main_handle_pulled()
	
	
func main_handle_pulled():
	lottery.handle_pulled()
	lottery_2.handle_pulled()
	lottery_3.handle_pulled()
	await get_tree().create_timer(5).timeout
	win_score()
	label_score.text = "WIN: " + str(score)
	texture_button_pull_bar.disabled = false


func win_score():
	if Global.DIAMOND == 2:
		score = 100
	elif Global.DIAMOND == 3:
		score = 200
	if Global.CROWN == 2:
		score = 300
	elif Global.CROWN == 3:
		score = 400
	if Global.WATERMELON == 2:
		score = 500
	elif Global.WATERMELON == 3:
		score = 600
	if Global.BAR == 2:
		score = 700
	elif Global.BAR == 3:
		score = 800
	if Global.SEVEN == 2:
		score = 1000
	elif Global.SEVEN == 3:
		score = 1500
	if Global.CHERRY == 2:
		score = 2000
	elif Global.CHERRY == 3:
		score = 3000
	if Global.LIMON == 2:
		score = 4000
	elif Global.LIMON == 3:
		score = 5000
	
