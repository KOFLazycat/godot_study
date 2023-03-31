extends Node2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 80
	call_deferred("drop_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func drop_out():
	audio_stream_player_2d.play()
	
	var r = randi_range(-250, 250)
	var d = randi_range(-180, 180)
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x + r, 1000), 1.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"rotation_degrees",d, 0.8).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	queue_free()
