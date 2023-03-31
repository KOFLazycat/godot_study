extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.glob_fly_cutter_num <= 0:
		queue_free()


func init_main(_pos):
	position = _pos
