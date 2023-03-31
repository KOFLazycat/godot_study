extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var fragment_lumber_tscn = preload("res://src/main/scene/level/fly_cutter/fragment_lumber.tscn")


var r_speed = 0
var d_flag = false

signal hited

# Called when the node enters the scene tree for the first time.
func _ready():
	init_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += r_speed * delta
	if Global.glob_next_flag == true and d_flag == false:
		r_speed = 0
		d_flag = true
		sprite_2d.visible = false
		rotation_degrees = 0
		call_deferred("spwan_fragment_lumber")
	

func init_main():
	position = Global.GLOB_WOOD_POS
	r_speed = Global.GLOB_ROTATION_SPEED
	z_index = 100
	sprite_2d.visible = true
	d_flag = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("fly_cutter"):
		audio_stream_player_2d.play()
#		await audio_stream_player_2d.finished
		emit_signal("hited")


func spwan_fragment_lumber():
	for i in range(4):
		var fragment_lumber = fragment_lumber_tscn.instantiate()
		fragment_lumber.rotation_degrees = i * 90
		add_child(fragment_lumber)
