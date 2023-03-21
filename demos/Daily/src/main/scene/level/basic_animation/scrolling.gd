extends Node2D

@onready var bg = $Bg
@onready var bg_2 = $Bg2

var speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	bg.position = Vector2(480, 160)
	bg_2.position = Vector2(1440, 160)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bg.position.x -= speed
	if bg.position.x < -480:
		bg.position.x = 1440
	bg_2.position.x -= speed
	if bg_2.position.x < -480:
		bg_2.position.x = 1440
