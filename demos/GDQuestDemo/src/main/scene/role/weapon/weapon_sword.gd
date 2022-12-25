extends Node2D

@onready var pivot = $Pivot
@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer
@onready var shadow_circle = $ShadowCircle



func use():
	audio_stream_player.pitch_scale = randf_range(1.7, 2.6)
	animation_player.play("slash")


func _physics_process(delta: float):
	var mouse_position := get_global_mouse_position()

	pivot.look_at(mouse_position)
	# 武器上下浮动
	pivot.position.y = sin(Time.get_ticks_msec() * delta * 0.20) * 10

	# Flip pivot to avoid upside down attacks
	if mouse_position.x - global_position.x < 0:
		pivot.scale.y = -1
	else:
		pivot.scale.y = 1

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		use()
