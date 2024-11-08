extends Node


var _author="lazycat"

var mainScene="res://src/main/scene/level/welcome/welcome.tscn"

#游戏状态
enum state {STATE_IDLE, STATE_START, STATE_OVER,STATE_HELP,
			STATE_NEWSCORE,STATE_PAUSE,STATE_RESUME,STATE_PASS,STATE_SCORE}
#方块状态
enum blockState{FAST,SLOW,STOP,SLOWMOVE,SHAKE}
#玩家
enum playerState{IDLE,STAND,JUMP,DEAD}

var nextState=state.STATE_IDLE

signal blockExit(pos_x)

var sound=true	#声音开关

var blockColor=['#a5aeb3','#22bdd1','#2a6aff','#ffc827','#00b264',
				'#5f6380','#ff702a','#fdfbc8','#ff4352','#ffa195']
var lineColor = ["#a5aeb3"]
var group={colorDot="colorDot",scoreDot="scoreDot"}
	
var words=['hello world','debug!!!','say no']	
	
const FILE_NAME = "user://game-data.json"

#保存的数据
var data = {
	"best_round": 0,
	"last_round": 0,
	"rounds_played": 0,
	"avg_per_round":0,
	"colors_earned":0,
	"sound":true
}

	
func _ready():
	printFont()
	data=loadFile()


#更改场景
func changeScene(stagePath):
	var splash_ani = Splash.get_node("AnimationPlayer")
	splash_ani.play("moveIn")
	await splash_ani.animation_finished
	set_process_input(false)
	get_tree().change_scene_to_file(stagePath)
	set_process_input(true)
	splash_ani.play("moveOut")
	await splash_ani.animation_finished


#保存数据
func save(data):
	var file = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file = null


#载入文件
func loadFile():
	if FileAccess.file_exists(FILE_NAME):
		var file = FileAccess.open(FILE_NAME, FileAccess.READ)
		var data_str = file.get_as_text()
		var load_data = ""
		if data_str != "":
			load_data = JSON.parse_string(data_str)
		file = null
		return load_data
	else:
		save(data)  #保存数据
#		printerr("No saved data!")
		return data

func addGamePlayNum():
	data['rounds_played']+=1
	save(data)

func recordGameData(colors_earned):
	data['rounds_played']+=1
	data['last_round']=colors_earned
	if data['best_round']<colors_earned:
		data['best_round']=colors_earned
	data['colors_earned']+=colors_earned
	var avg = float(data['colors_earned'])/data['rounds_played']
	data['avg_per_round']=avg
	save(data)

func printFont():
	print("""
 __    __    ___  _____   ___    ___ __    __    ___ 
|  |__|  |  /  _]/ ___/  /  _]  /  _]  |__|  |  /  _]
|  |  |  | /  [_(   \\_  /  [_  /  [_|  |  |  | /  [_ 
|  |  |  ||    _]\\__  ||    _]|    _]  |  |  ||    _]
|  `  '  ||   [_ /  \\ ||   [_ |   [_|  `  '  ||   [_ 
 \\      / |     |\\    ||     ||     |\\      / |     |
  \\_/\\_/  |_____| \\___||_____||_____| \\_/\\_/  |_____|
	""")
