extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


var speed = 1000
var velocity = Vector2.ZERO
var fire_flag = false
var d_flag = false

signal game_over


# Called when the node enters the scene tree for the first time.
func _ready():
	init_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	if Input.is_action_just_pressed("fire") and fire_flag == false and Global.glob_next_flag == false and Global.glob_fly_cutter_num > 0:
		fire_flag = true
		show()
		velocity = Vector2.UP * speed
		audio_stream_player_2d.play()
	
	if Global.glob_next_flag == true and d_flag == false and Global.glob_fly_cutter_num <= 0:
		d_flag = true
		hide()
		

func init_main():
	position = Global.GLOB_FLY_CUTTER_POS
	rotation_degrees = 0
	fire_flag = false
	d_flag = false
	show()


func _on_area_2d_area_entered(area):
	if area.is_in_group("lumber"):
		velocity = Vector2.ZERO
		position = Global.GLOB_FLY_CUTTER_POS
		fire_flag = false
	if area.is_in_group("half_fly_cutter") and Global.glob_next_flag == false:
		call_deferred("drop_out")


func drop_out():
	velocity = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x, 1000), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"rotation_degrees",180, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	hide()
	position = Global.GLOB_FLY_CUTTER_POS
	rotation_degrees = 0
	fire_flag = false
	emit_signal("game_over")
