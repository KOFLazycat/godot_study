extends Node2D


@export var gravity = Vector2(0, 980)

var _velocity = Vector2.ZERO

@onready var label = $Label
@onready var animation_player = $AnimationPlayer


func _init():
	set_as_top_level(true)


func _ready():
	_velocity = Vector2(randi_range(-200, 200), -300)


func _process(delta: float):
	_velocity += gravity * delta
	global_position += _velocity * delta
	

func set_damage(amount: int):
	if not label:
		await self.ready
		
	label.text = "-" + str(amount)
	animation_player.play("show")
