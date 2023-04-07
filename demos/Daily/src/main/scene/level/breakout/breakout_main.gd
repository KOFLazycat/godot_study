extends Node2D


@onready var brick_tscn = preload("res://src/main/scene/level/breakout/brick.tscn")
@onready var guard: Node2D = $Guard
@onready var ball: Node2D = $Ball
@onready var label_level: Label = $LabelLevel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.glob_level = 1
	Global.glob_score = 0
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(Global.glob_score)
	if Global.glob_score == Global.glob_level*6 and flag == false:
		flag = true
		Global.glob_level += 1
		if Global.glob_level > 6:
			label_level.text = "THAT IS ALL!"
			label_level.show()
			get_tree().paused = true
		else:
			reset()
	
	
func reset() -> void:
	Global.glob_start_game = false
	guard.add_scale_x()
	ball.add_scale()
	label_level.text = "level: " + str(Global.glob_level)
	label_level.show()
	guard.hide()
	ball.hide()
	await get_tree().create_timer(1).timeout
	label_level.hide()
	guard.show()
	ball.show()
	Global.glob_start_game = true
	next_level()


func next_level() -> void:
	var brick = null
	Global.glob_score = 0
	guard.position = Vector2(480, 670)
	for j in range(Global.glob_level):
		for i in range(6):
			brick = brick_tscn.instantiate()
			add_child(brick)
			brick.position.y = j*50 + 100
			brick.position.x = i*150 + 100
	ball.reset()
	flag = false


func _on_area_2d_down_area_entered(area: Area2D) -> void:
	if area.is_in_group("ball"):
		guard.position = Vector2(480, 670)
