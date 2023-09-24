extends Node2D

@onready var bottom_bar: TextureProgressBar = $Bar/BottomBar
@onready var top_bar: TextureProgressBar = $Bar/TopBar
@onready var timer: Timer = $Timer
@onready var timer_reduce: Timer = $TimerReduce


@export var interval_time: float = 1.0
@export var interval_reduce_time: float = 2.0
# 血量上限
@export var blood_max: int = 100
var blood_value: int = 0
var change_time = 0.1 # 血量变化tween变化时间
var change_buffer = 0.5 # 血量变化底部缓冲tween变化时间
var is_able_reduce: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(interval_time)
	init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_press_pressed() -> void:
	if is_able_reduce:
		is_able_reduce = false
		timer_reduce.start(interval_reduce_time)
		
	value_change(1)


func _on_timer_timeout() -> void:
	if is_able_reduce:
		value_change(-10)


func _on_timer_reduce_timeout() -> void:
	is_able_reduce = true
	timer_reduce.stop()
	

func init() -> void:
	bottom_bar.min_value = 0
	bottom_bar.max_value = blood_max
	bottom_bar.value = blood_value
	
	top_bar.min_value = 0
	top_bar.max_value = blood_max
	top_bar.value = blood_value
	value_change(blood_max)


func value_change(v: int) -> void:
	blood_value += v
	var bv: int = blood_value
	if blood_value <= 0:
		bv = 1
	if blood_value >= blood_max:
		bv = blood_max
	
	var tween = create_tween()
	if v < 0:
		tween.tween_property(top_bar,"value",bv, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(bottom_bar,"value",bv, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	if v > 0:
		tween.tween_property(bottom_bar,"value",bv, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(top_bar,"value",bv, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()

