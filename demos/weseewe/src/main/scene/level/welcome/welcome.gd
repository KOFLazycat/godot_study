extends Node2D

@onready var player = $Player/Player
@onready var spawn_block = $Block/SpawnBlock
@onready var sound_btn = $Ui/SoundBtn
@onready var color_timer = $ColorTimer
@onready var game_pass_timer = $GamePassTimer
@onready var game_over_timer = $GameOverTimer
@onready var score_dot_util = $Dot/ScoreDotUtil
@onready var color_dot_util = $Dot/ColorDotUtil
@onready var word = $Ui/Word
@onready var particle_util = $Bg/ParticleUtil
@onready var camera_2d = $Camera2D
@onready var animation_player = $AnimationPlayer
@onready var bg = $Bg
@onready var pause_btn = $Ui/PauseBtn
@onready var main_btn = $Ui/MainBtn
@onready var rank_btn = $Ui/RankBtn
@onready var author = $Ui/Author

var _scoreBoard
var _helpInfo

var offsety=60 #摄像机的y偏移
var state=Game.state.STATE_IDLE
var helpInfo =preload("res://src/main/scene/role/help/help_info.tscn")
var height #高度
var firstStart=true	#新增颜色定时器第一次启动
var getNewColordelay=18 #下一个新颜色的间隔
var scoreInfo = preload("res://src/main/scene/role/score/score_board.tscn")	#分数信息
var cameraStartPos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if  Game.data['sound']:
		sound_btn.button_pressed=false
		Sound.playWelcomMusic()
	else:
		sound_btn.button_pressed=true
	
	spawn_block.init()
	height=DisplayServer.window_get_size().y
	cameraStartPos = player.position
	game_over_timer.connect("timeout",Callable(self,"_gameOver"))
	color_timer.connect("timeout",Callable(self,"_addNewColor"))
	game_pass_timer.connect("timeout",Callable(self,"_gamePass"))
	
	if Game.nextState!=Game.state.STATE_IDLE:
		if Game.nextState==Game.state.STATE_START:
			setState(Game.state.STATE_START)
		elif Game.nextState==Game.state.STATE_NEWSCORE:
			animation_player.current_animation="newScore"
			score_dot_util.clear()
			word.clear()
			player.playMewScoreAni()
			var delay=0
			while delay<300:
				delay+=1
				if delay%20==0&&delay<100:
					particle_util.addRandomPosParticle(Vector2(randi()%80+120,460),true)
				await get_tree().physics_frame
			animation_player.play("new_score_back")
			score_dot_util.init(Game.data['best_round'])
			particle_util.startRandomParticle()
			word.init()		
		Game.nextState=Game.state.STATE_IDLE
	else:
		score_dot_util.init(Game.data['best_round'])
		particle_util.startRandomParticle()
		word.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state==Game.state.STATE_IDLE:
		pass
	elif state==Game.state.STATE_HELP:
		if  player.position.y>cameraStartPos.y:
			camera_2d.offset.y-=(player.position.y-cameraStartPos.y)*0.09
		else:
			camera_2d.offset.y+=(cameraStartPos.y-player.position.y)*0.09

		cameraStartPos=player.position	
		if camera_2d.offset.y<280:
			camera_2d.offset.y=280
		elif camera_2d.offset.y>320:
			camera_2d.offset.y=320
	elif state==Game.state.STATE_START:
		if  player.position.y>cameraStartPos.y:
			camera_2d.offset.y-=(player.position.y-cameraStartPos.y)*0.09
		else:
			camera_2d.offset.y+=(cameraStartPos.y-player.position.y)*0.09

		cameraStartPos=player.position	
	
		if camera_2d.offset.y<280:
			camera_2d.offset.y=280
		elif camera_2d.offset.y>320:
			camera_2d.offset.y=320
		#如果玩家位置超出屏幕就游戏结束	
		if player.position.x<-player.size/2:
			setState(Game.state.STATE_OVER)
		if player.position.y>height+offsety+player.size/2+30:
			setState(Game.state.STATE_OVER)
	elif state==Game.state.STATE_OVER:#游戏结束
		pass
	elif state==Game.state.STATE_PAUSE:
		pass
	elif state==Game.state.STATE_PASS:
		pass
	elif state==Game.state.STATE_SCORE:
		pass


#设置状态	
func setState(state):
	if state==Game.state.STATE_HELP:
		animation_player.play("help")
		player.setState(Game.playerState.STAND)
		spawn_block.setState(Game.blockState.FAST)	
		_helpInfo=helpInfo.instantiate()
		bg.add_child(_helpInfo)
		score_dot_util.clear()
		word.clear()
		color_dot_util.add3Dot(spawn_block.allColor.slice(0,2))
		spawn_block.setGameState(Game.state.STATE_HELP)
		self.state=state
	elif state==Game.state.STATE_IDLE:
		if self.state==Game.state.STATE_PAUSE: #从游戏开始返回
			get_tree().paused=false
			Game.changeScene(Game.mainScene)
		elif self.state==Game.state.STATE_PASS:	#已经通关
			Game.changeScene(Game.mainScene)
		elif self.state==Game.state.STATE_SCORE:	#分数
			animation_player.play_backwards("score")
			score_dot_util.init(Game.data['best_round'])
			word.init()
			_scoreBoard.queue_free()
		else:
			player.setState(Game.playerState.IDLE)
			spawn_block.setGameState(Game.state.STATE_IDLE)
			_helpInfo.queue_free()
			score_dot_util.init(Game.data['best_round'])
			word.init()
			color_dot_util.clearColor()
			animation_player.play_backwards("help")
			await animation_player.animation_finished
			spawn_block.setState(Game.blockState.SLOW)
		self.state=state
	elif state==Game.state.STATE_START:
		self.state=state
		if Game.data['sound']:
			Sound.playGameStartMusic()
		particle_util.stopRandomParticle()
		animation_player.play("start")
		score_dot_util.clear()
		word.clear()
		player.setState(Game.playerState.STAND)
		player.playAni()
		spawn_block.setState(Game.blockState.FAST)
		await animation_player.animation_finished
		spawn_block.setGameState(Game.state.STATE_START)
		color_dot_util.addAllJoint()	#添加关节
		color_timer.start(1)	#游戏开始	
	elif state==Game.state.STATE_OVER:#游戏结束
		player.setState(Game.playerState.DEAD)
		spawn_block.setState(Game.blockState.SHAKE)
		if player.position.x<-player.size/2:
			particle_util.addEdgeParticle(Vector2(0,player.position.y),false)
		else:
			particle_util.addRandomPosParticle(Vector2(player.position.x,400),false)
		
		Sound.playPop()
		Sound.stopTrack()
#		saveData()	#保存数据
		
		pause_btn.visible=false
		game_over_timer.start()
		self.state=state
	elif state==Game.state.STATE_NEWSCORE:
		self.state=state
	elif state==Game.state.STATE_PAUSE:
		get_tree().paused=true
		if Game.data['sound']:
			Sound.stopTrack()
		animation_player.play("pause")
		player.setState(Game.playerState.IDLE)
		spawn_block.setState(Game.blockState.STOP)
		self.state=state
	elif state==Game.state.STATE_RESUME:
		get_tree().paused=false
		if Game.data['sound']:
			Sound.playWelcomMusic()
		animation_player.play_backwards("pause")
		player.setState(Game.playerState.STAND)
		spawn_block.setState(Game.blockState.FAST)
		spawn_block.setGameState(Game.state.STATE_START)
		color_timer.start()
		self.state=Game.state.STATE_START
	elif state==Game.state.STATE_PASS:
		main_btn.set_position(Vector2(3,394))
		spawn_block.setState(Game.blockState.SLOW)
		spawn_block.setGameState(Game.state.STATE_PASS)
		rank_btn.visible=false
		author.visible=true
#		saveData()	#保存数据
		var delay=0
		while delay<300:
			delay+=1
			if delay%30==0:
				particle_util.addRandomPosParticle(Vector2(randi()%80+120,460),false)
			await get_tree().physics_frame
		self.state=state
	elif state==Game.state.STATE_SCORE:	#分数显示
		self.state=state
		score_dot_util.clear()
		word.clear()
		_scoreBoard = scoreInfo.instantiate()
		$ui.add_child(_scoreBoard)
		animation_player.play("score")


#游戏结束后定时器	
func _gameOver():
	Game.changeScene(Game.mainScene)
	
#添加新颜色
func _addNewColor():
	Sound.playColor()	#新颜色声音
	if firstStart:
		color_timer.stop()
		color_timer.wait_time=getNewColordelay
		color_timer.start()
		firstStart=false
	var block = spawn_block
	block.addNewColor()
	if block.useColor.size()>=10:	#如果已经是1个
		game_pass_timer.start()#通关定时器
		color_timer.stop()
		color_dot_util.addDot(block.useColor[block.useColor.size()-1])
	else:
		color_dot_util.addDot(block.useColor[block.useColor.size()-1])

#游戏通关		
func _gamePass():
	setState(Game.state.STATE_PASS)

#保存数据
func saveData():
	var colorsNum= spawn_block.useColor.size()
	if colorsNum>Game.data['best_round']:
		Game.nextState=Game.state.STATE_NEWSCORE
	Game.recordGameData(colorsNum)#记录数据


func _on_help_btn__pressed():
	setState(Game.state.STATE_HELP)


func _on_start_btn__pressed():
	setState(Game.state.STATE_START)


func _on_sound_btn__pressed():
	if Game.data['sound']:
		Game.data['sound']=false
		Sound.stopTrack()
	else:
		Game.data['sound']=true
		Sound.playWelcomMusic()
	Game.save(Game.data)


func _on_score_btn__pressed():
	setState(Game.state.STATE_SCORE)


func _on_main_btn__pressed():
	setState(Game.state.STATE_IDLE)


func _on_pause_btn__pressed():
	setState(Game.state.STATE_PAUSE)


func _on_resume_btn__pressed():
	setState(Game.state.STATE_RESUME)


func _on_restart_btn__pressed():
	get_tree().paused=false
	Game.nextState=Game.state.STATE_START
	Game.changeScene(Game.mainScene)
