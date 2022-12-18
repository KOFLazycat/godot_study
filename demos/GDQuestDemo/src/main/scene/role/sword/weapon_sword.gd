extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

const DRAG_FACTOR := 15.0
const RUN_SPEED := 600.0

var _velocity := Vector2.ZERO


func _ready():
	print(rotation)
	

func _physics_process(delta):
	var input_direction := Vector2.ZERO
	input_direction = Vector2(Input.get_axis("move_left", "move_right"),Input.get_axis("move_up", "move_down"))
	var desired_velocity := input_direction * RUN_SPEED
	var steering = desired_velocity - _velocity
	_velocity += steering * DRAG_FACTOR * delta
	position += _velocity * delta


func _input(event):
	if event.is_action_pressed("attack"):
		animation_player.play("sword_attack")


