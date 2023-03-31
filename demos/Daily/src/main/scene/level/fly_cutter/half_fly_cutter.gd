extends Node2D


var r_speed = 0
var d_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	init_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += r_speed * delta
	if Global.glob_next_flag == true and d_flag == false:
		r_speed = 0
		d_flag = true
		call_deferred("drop_out")


func init_main():
	position = Global.GLOB_WOOD_POS
	r_speed = Global.GLOB_ROTATION_SPEED
	z_index = 90
	show()


func drop_out():
	
	var r = randi_range(-200, 200)
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x + r, 1000), 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"rotation_degrees",-180, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	queue_free()
