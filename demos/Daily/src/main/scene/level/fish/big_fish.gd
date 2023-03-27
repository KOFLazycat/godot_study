extends Node2D

@onready var fish = $Fish
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(480, 360)
	scale = Vector2(0.2, 0.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	position = lerp(position, get_global_mouse_position(), 0.01)


func _on_area_2d_area_entered(area):
	if area.is_in_group("little_fish"):
		fish.frame = 1
		audio_stream_player_2d.play()
		await  audio_stream_player_2d.finished
		fish.frame = 0
		scale += Vector2(0.01, 0.01)
