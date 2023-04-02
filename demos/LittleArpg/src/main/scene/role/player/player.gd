extends CharacterBody2D


@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D


@export var speed: int = 35


func _ready():
	camera_2d.limit_left = 0
	camera_2d.limit_right = 1920
	camera_2d.limit_top = 0
	camera_2d.limit_bottom = 1080

func _physics_process(delta):
	handleInput()
	move_and_slide()


func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	updateAnimation()

func updateAnimation():
	if velocity == Vector2.ZERO:
		if animation_player.is_playing():
			animation_player.stop()
	else:
		var dir = "down"
		if velocity.x < 0:
			dir = "left"
		elif velocity.x > 0:
			dir = "right"
		elif velocity.y < 0:
			dir = "up"
		animation_player.play("walk_" + dir)
	
