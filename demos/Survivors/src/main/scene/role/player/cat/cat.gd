extends CharacterBody2D


@export var movement_speed = 40.0
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D


func _physics_process(delta):
	movement()
	

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x < 0:
		sprite_2d.flip_h = true
	if mov.x > 0:
		sprite_2d.flip_h = false
	
	var movement_speed_offset = 0
	if mov == Vector2.ZERO:
		animation_player.play("idle1")
	else:
		animation_player.play("walk1")
		
	velocity = mov.normalized()*(movement_speed + movement_speed_offset)
	move_and_slide()
