extends Node2D

@onready var label_score = $LabelScore
@onready var timer = $Timer
@onready var lumber = $Lumber
@onready var fly_cutter = $FlyCutter

@onready var half_fly_cutter_tscn = preload("res://src/main/scene/level/fly_cutter/half_fly_cutter.tscn")
@onready var apple_tscn = preload("res://src/main/scene/level/fly_cutter/apple.tscn")
@onready var white_fly_cutter_tscn = preload("res://src/main/scene/level/fly_cutter/white_fly_cutter.tscn")
@onready var black_fly_cutter_tscn = preload("res://src/main/scene/level/fly_cutter/black_fly_cutter.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.glob_score = 0
	init_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_score.text = str(Global.glob_score)
	

func init_main():
	var apple_count = randi()%4 + 1
	for i in range(apple_count):
		var apple = apple_tscn.instantiate()
		add_child(apple)
	Global.glob_fly_cutter_num = apple_count + 2
	
	for i in range(1, Global.glob_fly_cutter_num + 1):
		var black_fly_cutter = black_fly_cutter_tscn.instantiate()
		add_child(black_fly_cutter)
		black_fly_cutter.init_main(Vector2(300, 600 - i * 30))
	for i in range(1, Global.glob_fly_cutter_num):
		var white_fly_cutter = white_fly_cutter_tscn.instantiate()
		add_child(white_fly_cutter)
		white_fly_cutter.init_main(Vector2(300, 600 - i * 30), i)
	
	timer.one_shot = true


func _on_lumber_hited():
	call_deferred("spwan_half_fly_cutter")
	Global.glob_fly_cutter_num -= 1
	if Global.glob_fly_cutter_num <= 0:
		Global.glob_next_flag = true
		timer.start(2)


func _on_timer_timeout():
	Global.glob_next_flag = false
	init_main()
	lumber.init_main()
	fly_cutter.init_main()


func _on_fly_cutter_game_over():
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/fly_cutter/start.tscn")
	if err != OK:
		print("Start Scene Loading Error...")


func spwan_half_fly_cutter():
	var half_fly_cutter = half_fly_cutter_tscn.instantiate()
	add_child(half_fly_cutter)


