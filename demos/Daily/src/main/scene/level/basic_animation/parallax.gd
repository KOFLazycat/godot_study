extends Node2D

@onready var bg = $bg
@onready var back_bg = $back_bg
@onready var mid_bg = $mid_bg
@onready var front_bg = $front_bg


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.g_speed > 1.0:
		back_bg.scroll_base_offset.x -= Global.g_speed*20*delta
		mid_bg.scroll_base_offset.x -= Global.g_speed*40*delta
		front_bg.scroll_base_offset.x -= Global.g_speed*60*delta
