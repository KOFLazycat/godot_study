extends Node2D

@export var gravity := Vector2(0, 980)

var _velocity := Vector2.ZERO

@onready var _label := $Label
@onready var _animation_player := $AnimationPlayer


func _init():
	set_as_top_level(true)


func _ready() -> void:
	_velocity = Vector2(randf_range(-200, 200), -300)


func _process(delta: float) -> void:
	_velocity += gravity * delta
	global_position += _velocity * delta
	

func set_damage(amount: int) -> void:
	if not _label:
		await self.ready
	_label.text = "-" + str(amount)
	_animation_player.play("show")
