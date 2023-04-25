extends Node2D


@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var button: Button = $Button

@onready var color_ball: RigidBody2D = $Ball/ColorBall
@onready var color_ball_2: RigidBody2D = $Ball/ColorBall2
@onready var color_ball_3: RigidBody2D = $Ball/ColorBall3
@onready var color_ball_4: RigidBody2D = $Ball/ColorBall4
@onready var color_ball_5: RigidBody2D = $Ball/ColorBall5
@onready var color_ball_6: RigidBody2D = $Ball/ColorBall6
@onready var color_ball_7: RigidBody2D = $Ball/ColorBall7
@onready var color_ball_8: RigidBody2D = $Ball/ColorBall8
@onready var color_ball_9: RigidBody2D = $Ball/ColorBall9
@onready var color_ball_10: RigidBody2D = $Ball/ColorBall10
@onready var color_ball_11: RigidBody2D = $Ball/ColorBall11
@onready var color_ball_12: RigidBody2D = $Ball/ColorBall12
@onready var color_ball_13: RigidBody2D = $Ball/ColorBall13
@onready var color_ball_14: RigidBody2D = $Ball/ColorBall14
@onready var color_ball_15: RigidBody2D = $Ball/ColorBall15


@onready var white_ball_tscn = preload("res://src/main/scene/level/billiard/white_ball.tscn")


var ball_record: Array = []
var ball_num: int = 0
var hit_ball = null


func _ready() -> void:
	ball_record.append($Record/Sprite2D)
	ball_record.append($Record/Sprite2D2)
	ball_record.append($Record/Sprite2D3)
	ball_record.append($Record/Sprite2D4)
	ball_record.append($Record/Sprite2D5)
	ball_record.append($Record/Sprite2D6)
	ball_record.append($Record/Sprite2D7)
	ball_record.append($Record/Sprite2D8)
	ball_record.append($Record/Sprite2D9)
	ball_record.append($Record/Sprite2D10)
	ball_record.append($Record/Sprite2D11)
	ball_record.append($Record/Sprite2D12)
	ball_record.append($Record/Sprite2D13)
	ball_record.append($Record/Sprite2D14)
	ball_record.append($Record/Sprite2D15)
	
	spawn_white_ball()
	button.hide()
	

func _process(delta: float) -> void:
	ray_cast_2d.position = hit_ball.position
	var dir = (hit_ball.position - get_global_mouse_position()).normalized()
	var angle = atan2(dir.y, dir.x)
	ray_cast_2d.rotation = angle
	if ray_cast_2d.is_colliding():
		line_2d.points = [hit_ball.position, ray_cast_2d.get_collision_point()]
	else:
		line_2d.clear_points()
	
	
func spawn_white_ball() -> void:
	hit_ball = white_ball_tscn.instantiate()
	add_child(hit_ball)
	hit_ball.position = Vector2(300, 357)


func _on_area_2d_hole_body_entered(body: Node2D) -> void:
	if body.is_in_group("color_ball"):
		ball_record[ball_num].texture = body.texture
		body.queue_free()
		ball_num += 1
		if ball_num == 15:
			button.show()
	else:
		body.queue_free()
		call_deferred("spawn_white_ball")


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
