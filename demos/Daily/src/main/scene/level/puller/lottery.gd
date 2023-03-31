extends Node2D

@onready var sprite_2d_result = $Sprite2DResult

var time_interval = 0.01
var kjjg_y = [-390, -280, -160, -50, 50, 160, 265]
var speed = 30
var speed_decline = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	
	sprite_2d_result.position = Vector2(0, kjjg_y[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func handle_pulled():
	var a = randi_range(100, 300)
	var b = randi_range(0, 6)
	for i in range(a):
		if sprite_2d_result.position.y >= 300:
			sprite_2d_result.position.y = kjjg_y[0]
		else:
			sprite_2d_result.position.y += speed
		await get_tree().create_timer(time_interval).timeout
	sprite_2d_result.position.y = kjjg_y[b]
	match (b):
		0: Global.DIAMOND += 1
		1: Global.CROWN += 1
		2: Global.WATERMELON += 1
		3: Global.BAR += 1
		4: Global.SEVEN += 1
		5: Global.CHERRY += 1
		6: Global.LIMON += 1
	
