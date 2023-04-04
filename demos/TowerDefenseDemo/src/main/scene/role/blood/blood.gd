extends Node2D

@onready var blood_bottom: TextureProgressBar = $BloodBottom
@onready var blood_top: TextureProgressBar = $BloodTop

var blood_red = preload("res://src/main/assets/texture/blood/blood_red.png")
var blood_green = preload("res://src/main/assets/texture/blood/blood_green.png")
var blood_yellow = preload("res://src/main/assets/texture/blood/blood_yellow.png")

var blood_value = 100
var change_time = 0.1 # 血量变化tween变化时间
var change_buffer = 0.5 # 血量变化底部缓冲tween变化时间
# Called when the node enters the scene tree for the first time.
func _ready():
	blood_bottom.min_value = 0
	blood_bottom.max_value = 100
	blood_bottom.value = blood_value
	
	blood_top.min_value = 0
	blood_top.max_value = 100
	blood_top.value = blood_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if blood_value > 60 and blood_value <= 100:
		blood_top.texture_progress = blood_green
	if blood_value > 30 and blood_value <= 60:
		blood_top.texture_progress = blood_yellow
	if blood_value >= 0 and blood_value <= 30:
		blood_top.texture_progress = blood_red


func value_change(blood_v: int) -> void:
	blood_value += blood_v
	var bv = blood_value
	if blood_value <= 0:
		bv = 1
	
	var tween = create_tween()
	if blood_v < 0:
		tween.tween_property(blood_top,"value",bv, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(blood_bottom,"value",bv, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	if blood_v > 0:
		tween.tween_property(blood_bottom,"value",bv, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(blood_top,"value",bv, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	
