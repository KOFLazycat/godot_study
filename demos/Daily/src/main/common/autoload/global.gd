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

# 圆木和插在圆木上的飞刀以及圆木上的苹果旋转的速度常量
const GLOB_ROTATION_SPEED = 100
# 飞刀在游戏窗体里的坐标
const GLOB_FLY_CUTTER_POS = Vector2(480, 550)
# 圆木在游戏窗体里的坐标
const GLOB_WOOD_POS = Vector2(480, 200)
# 开始下一局游戏的标志
var glob_next_flag = false
# 记录飞刀刺中苹果后得分变量
var glob_score = 0
# 每一局游戏可以使用的飞刀数量
var glob_fly_cutter_num = 0


func reset():
	DIAMOND = 0
	CROWN = 0
	WATERMELON = 0
	BAR = 0
	SEVEN = 0
	CHERRY = 0
	LIMON = 0
