extends Node2D


var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if id == Global.glob_fly_cutter_num:
		queue_free()


func init_main(_pos, _id):
	position = _pos
	id = _id
