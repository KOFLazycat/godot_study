extends Node2D

@onready var blood_bottom: TextureProgressBar = $Bottom
@onready var blood_top: TextureProgressBar = $Top

var blood_red = preload("res://src/main/assets/texture/blood/blood_red.png")
var blood_green = preload("res://src/main/assets/texture/blood/blood_green.png")
var blood_yellow = preload("res://src/main/assets/texture/blood/blood_yellow.png")

# 血量上限
@export var blood_max: int = 100
# 绿色血条最低系数
@export var green_factor: float = 0.6
# 黄色血条最低系数
@export var yellow_factor: float = 0.3
## 红色血条最低系数
#@export var red_factor: float = 0.1
var blood_value: int = 0
var change_time = 0.1 # 血量变化tween变化时间
var change_buffer = 0.8 # 血量变化底部缓冲tween变化时间
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init() -> void:
	blood_bottom.min_value = 0
	blood_bottom.max_value = blood_max
	blood_bottom.value = blood_value
	
	blood_top.min_value = 0
	blood_top.max_value = blood_max
	blood_top.value = blood_value
	value_change(blood_max)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if blood_value > green_factor*blood_max and blood_value <= blood_max:
		blood_top.texture_progress = blood_green
	if blood_value > yellow_factor*blood_max and blood_value <= green_factor*blood_max:
		blood_top.texture_progress = blood_yellow
	if blood_value >= 0 and blood_value <= yellow_factor*blood_max:
		blood_top.texture_progress = blood_red


func value_change(v: int) -> void:
	blood_value += v
	var bv = blood_value
	if blood_value <= 0:
		bv = 1
	
	var tween = create_tween()
	if v < 0:
		tween.tween_property(blood_top,"value",bv, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(blood_bottom,"value",bv, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	if v > 0:
		tween.tween_property(blood_bottom,"value",bv, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(blood_top,"value",bv, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	
