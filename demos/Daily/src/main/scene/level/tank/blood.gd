extends Node2D

# 用于制作血条扣减缓冲效果
@onready var texture_progress_bar_bottom: TextureProgressBar = $TextureProgressBar_Bottom
@onready var texture_progress_bar = $TextureProgressBar
@onready var label_num = $LabelNum

var hp_red = preload("res://src/main/assets/texture/tank/血条/healthbar_red.png")
var hp_green = preload("res://src/main/assets/texture/tank/血条/healthbar_green.png")
var hp_yellow = preload("res://src/main/assets/texture/tank/血条/healthbar_yellow.png")


var hp_value = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	texture_progress_bar.min_value = 0
	texture_progress_bar.max_value = 100
	texture_progress_bar.value = hp_value
	
	texture_progress_bar_bottom.min_value = 0
	texture_progress_bar_bottom.max_value = 100
	texture_progress_bar_bottom.value = hp_value
	label_num.text = str(hp_value) + "%"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp_value > 60 and hp_value <= 100:
		texture_progress_bar.texture_progress = hp_green
#	if hp_value > 30 and hp_value <= 60:
#		texture_progress_bar.texture_progress = hp_yellow
	if hp_value >= 0 and hp_value <= 30:
		texture_progress_bar.texture_progress = hp_red
	var tween = create_tween()
	tween.tween_property(texture_progress_bar,"value",hp_value, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(texture_progress_bar_bottom,"value",hp_value, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	label_num.text = str(hp_value) + "%"
