extends Node
#游戏中的一些状态和功能

#场景
var mainScene="res://src/main/scene/level/main/main.tscn"
var welcomeScene="res://src/main/scene/level/welcome/welcome.tscn"

#得分显示不同的奖牌 铜牌到白金
const MEDAL_BRONZE   = 1
const MEDAL_SILVER   = 20
const MEDAL_GOLD     = 40
const MEDAL_PLATINUM = 60

#bird的状态
var idle=101
var fly=102
var play=103
var dead=105

#pipe的状态
var move=1001	#移动
var stop=1002	#停止
#地面的状态
var slow=1003	#缓慢移动
var fast=1004	#快速移动


#游戏的状态
var startGame=2001
var endGame=2002
var stopGame=2003

#分组信息
var group_bird="group_bird"
var group_pipe="group_pipe"
var group_ground="group_ground"

#分数
var score=20
var highScore=0

#窗口大小
var winHeight
var winWidth

signal scoreChange	#分数变化


func _ready():
	printFont()
	winWidth=ProjectSettings.get_setting("display/window/size/viewport_width")
	winHeight=ProjectSettings.get_setting("display/window/size/viewport_height")
	#OS.center_window()
	print(winHeight)
	print("[Screen Metrics]")
	print("Display size: ", DisplayServer.screen_get_size())
	print("Decorated Window size: ", DisplayServer.window_get_size_with_decorations())
	print("Window size: ", DisplayServer.window_get_size())
	print("Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(DisplayServer.window_get_size().x)
	print(DisplayServer.window_get_size().y)
	

#更改场景
func changeScene(stagePath):
	set_process_input(false)

	if AudioPlayer:
		AudioPlayer.playSfxSwooshing()

	if Splash:
		var ani=Splash.get_node("AnimationPlayer")
		ani.play("fade_in")
		await ani.animation_finished

	get_tree().change_scene_to_file(stagePath)

	if Splash:
		var ani=Splash.get_node("AnimationPlayer")
		ani.play("fade_out")
		await ani.animation_finished

	set_process_input(true)
	
	
#获取每个数字
func get_digits(number):
	var str_number = str(number)
	var digits     = []
	
	for i in range(str_number.length()):
		digits.append(str_number[i].to_int())
	return digits

func printFont():
	print("""
 _____  _       ____  ____  ____  __ __      ____   ____  ____   ___   
|     || |     /    ||    \\|    \\|  |  |    |    \\ |    ||    \\ |   \\  
|   __|| |    |  o  ||  o  )  o  )  |  |    |  o  ) |  | |  D  )|    \\ 
|  |_  | |___ |     ||   _/|   _/|  ~  |    |     | |  | |    / |  D  |
|   _] |     ||  _  ||  |  |  |  |___, |    |  O  | |  | |    \\ |     |
|  |   |     ||  |  ||  |  |  |  |     |    |     | |  | |  .  \\|     |
|__|   |_____||__|__||__|  |__|  |____/     |_____||____||__|\\_||_____|
	""")
