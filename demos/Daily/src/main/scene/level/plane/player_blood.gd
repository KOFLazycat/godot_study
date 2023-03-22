extends Node2D

@onready var texture_progress_bar = $TextureProgressBar

var b_red = preload("res://src/main/assets/texture/health/healthbar_red.png")
var b_green = preload("res://src/main/assets/texture/health/healthbar_green.png")
var b_yellow = preload("res://src/main/assets/texture/health/healthbar_yellow.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_progress_bar.min_value = 0
	texture_progress_bar.max_value = 100
	texture_progress_bar.value = Global.g_hp_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.g_hp_value > 60 and Global.g_hp_value <= 100:
		texture_progress_bar.texture_progress = b_green
	if Global.g_hp_value > 30 and Global.g_hp_value <= 60:
		texture_progress_bar.texture_progress = b_yellow
	if Global.g_hp_value >= 0 and Global.g_hp_value <= 30:
		texture_progress_bar.texture_progress = b_red
	var tween = create_tween()
	tween.tween_property(texture_progress_bar,"value",Global.g_hp_value, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.play()
