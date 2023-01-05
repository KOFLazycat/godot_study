extends Node2D


@onready var pipe = $Pipe
@onready var pipe_2 = $Pipe2
@onready var pipe_3 = $Pipe3
@onready var ground = $Ground
@onready var ground_2 = $Ground2
@onready var bird = $Bird
@onready var timer = $Timer
@onready var score = $Score
@onready var get_ready = $GetReady
@onready var animation_player = $GetReady/AnimationPlayer
@onready var pause_btn = $PauseBtn
@onready var camera_2d = $Camera2D
@onready var game_over_panel = $GameOverPanel
@onready var pause_panel = $PausePanel
@onready var game_over_ani = $GameOverPanel/GameOverAni
@onready var medal = $GameOverPanel/Panel/Medal
@onready var spark = $GameOverPanel/Panel/Medal/Spark
@onready var score_container = $GameOverPanel/Panel/ScoreContainer
@onready var score_container_score = $GameOverPanel/Panel/ScoreContainer/Score
@onready var best_container = $GameOverPanel/Panel/BestContainer
@onready var best_container_best = $GameOverPanel/Panel/BestContainer/Best
@onready var tip_btn = $TipBtn
@onready var new_high_score = $GameOverPanel/Panel/NewHighScore
@onready var btn_container = $GameOverPanel/BtnContainer


#分数图片
const sprite_numbers = [
	preload("res://src/main/assets/texture/number/number_large_01.png"),
	preload("res://src/main/assets/texture/number/number_large_11.png"),
	preload("res://src/main/assets/texture/number/number_large_21.png"),
	preload("res://src/main/assets/texture/number/number_large_31.png"),
	preload("res://src/main/assets/texture/number/number_large_41.png"),
	preload("res://src/main/assets/texture/number/number_large_51.png"),
	preload("res://src/main/assets/texture/number/number_large_61.png"),
	preload("res://src/main/assets/texture/number/number_large_71.png"),
	preload("res://src/main/assets/texture/number/number_large_81.png"),
	preload("res://src/main/assets/texture/number/number_large_91.png")
]

#最后得分
const sprite_mid_numbers = [
	preload("res://src/main/assets/texture/number/number_middle_01.png"),
	preload("res://src/main/assets/texture/number/number_middle_11.png"),
	preload("res://src/main/assets/texture/number/number_middle_21.png"),
	preload("res://src/main/assets/texture/number/number_middle_31.png"),
	preload("res://src/main/assets/texture/number/number_middle_41.png"),
	preload("res://src/main/assets/texture/number/number_middle_51.png"),
	preload("res://src/main/assets/texture/number/number_middle_61.png"),
	preload("res://src/main/assets/texture/number/number_middle_71.png"),
	preload("res://src/main/assets/texture/number/number_middle_81.png"),
	preload("res://src/main/assets/texture/number/number_middle_91.png")
]

#奖牌的图片
const spr_medal_bronze   = preload("res://src/main/assets/texture/medal/medal_bronze1.png")
const spr_medal_silver   = preload("res://src/main/assets/texture/medal/medal_silver1.png")
const spr_medal_gold     = preload("res://src/main/assets/texture/medal/medal_gold1.png")
const spr_medal_platinum = preload("res://src/main/assets/texture/medal/medal_platinum1.png")

var state=Game.startGame	#默认游戏开始状态

var offsetNum=16	#摄像机偏移次数
var magnitude = 4  #偏移
var num=0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Game.connect("scoreChange",Callable(self,"_on_score_changed"))
	pipe.setRandomYpos()
	pipe_2.setRandomYpos()
	pipe_3.setRandomYpos()
	Game.score=0
	bird.connect("birdStateChange", Callable(self,"_on_bird_state_change"))
	timer.connect("timeout", Callable(self,"_on_timeout"))
	bird.setState(Game.fly)


#碰到地面和水管
func _on_bird_state_change():
	gameOver()


#分数变化
func _on_score_changed():
	Game.score+=1
	#播放声音
	if AudioPlayer:
		AudioPlayer.playSfxPoint()
	
	#设置分数
	for child in score.get_children():
		child.queue_free()
	
	for i in Game.get_digits(Game.score):
		var rect = TextureRect.new()
		rect.texture=sprite_numbers[i]
		score.add_child(rect)


#定时器时间到
func _on_timeout():
	if state==Game.startGame:
		animation_player.play("fade_out")
		startGame()


#游戏开始
func startGame():
	pipe.state=Game.move
	pipe_2.state=Game.move
	pipe_3.state=Game.move
	ground.state=Game.fast
	ground_2.state=Game.fast
	

#游戏结束
func gameOver():
	#游戏结束
	if get_ready.visible:
		get_ready.hide()
	score.visible=false
	pause_btn.visible=false
	state=Game.endGame
	pipe.setState(Game.stop)
	pipe_2.setState(Game.stop)
	pipe_3.setState(Game.stop)
	ground.setState(Game.stop)
	ground_2.setState(Game.stop)
	bird.setState(Game.dead)
	
	while num<offsetNum:		
		camera_2d.offset.x += randf_range(-magnitude,magnitude)
		camera_2d.offset.y+=randf_range(-magnitude,magnitude)
		num+=1
		magnitude-=0.07
		await get_tree().process_frame
	num=0
	magnitude=3
	camera_2d.offset.x=144
	camera_2d.offset.y=256
	#showGameOverPanel()
	setFinalScore()


#设置最后的分数
func setFinalScore():
	game_over_panel.show()
	game_over_ani.play("idle")
	await game_over_ani.animation_finished
#	for child in $game/gameOverPanel/panel/scoreContainer.get_children():
#		child.queue_free()
	Game.score=100
	#设置奖牌
	var texture
	if Game.score>=Game.MEDAL_BRONZE:
		texture = spr_medal_bronze
	if Game.score>=Game.MEDAL_SILVER:
		texture = spr_medal_silver
	if Game.score>=Game.MEDAL_GOLD:
		texture=spr_medal_gold
	if Game.score>=Game.MEDAL_PLATINUM:
		texture=spr_medal_platinum
	if texture:
		medal.texture=texture
		spark.show()
	
	var num = 0
	var lerp_time     = 0
	var lerp_duration = 0.8
	while lerp_time < lerp_duration:	
		lerp_time += get_process_delta_time()
		lerp_time = min(lerp_time, lerp_duration)
		
		var percent = lerp_time / lerp_duration
		for child in score_container.get_children():
			child.queue_free()	
		for i in Game.get_digits(int(lerp(0,Game.score,percent))):
			var rect = TextureRect.new()
			rect.texture=sprite_mid_numbers[i]
			score_container.add_child(rect)
		await get_tree().process_frame
	#设置最高分
	if Game.score>Game.highScore:
		Game.highScore=Game.score
		new_high_score.show()
	
	for child in best_container.get_children():
		child.queue_free()
	for i in Game.get_digits(Game.highScore):
		var rect = TextureRect.new()
		rect.texture=sprite_mid_numbers[i]
		best_container.add_child(rect)
	btn_container.visible=true


#继续游戏
func _on_resume_btn_pressed():
	get_tree().paused=false
	pause_panel.hide()


#返回开始界面
func _on_menu_btn_pressed():
	get_tree().paused=false
	Game.changeScene(Game.welcomeScene)


#暂停按钮
func _on_pause_btn_pressed():
	get_tree().paused=true
	pause_panel.show()

#显示游戏结束界面
func showGameOverPanel():
	game_over_panel.show()
	game_over_ani.play("idle")


#重新开始
func _on_restart_btn_pressed():
	Game.changeScene(Game.mainScene)


#游戏开始
func _on_tip_btn_pressed():
	tip_btn.hide()
	bird.setState(Game.play)
	timer.start()
