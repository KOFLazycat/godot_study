extends Node


var g_speed = 1.0
var g_hp_value = 100

var DIAMOND = 0
var CROWN = 0
var WATERMELON = 0
var BAR = 0
var SEVEN = 0
var CHERRY = 0
var LIMON = 0

# klotski 标记选择是哪一个木头方块
var glob_id = 0
# klotski 标记当前游戏关卡
var glob_level = 1


func reset():
	DIAMOND = 0
	CROWN = 0
	WATERMELON = 0
	BAR = 0
	SEVEN = 0
	CHERRY = 0
	LIMON = 0
