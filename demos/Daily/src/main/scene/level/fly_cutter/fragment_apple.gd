extends Node2D


@onready var sprite_2d_left = $Sprite2DLeft
@onready var sprite_2d_right = $Sprite2DRight


# Called when the node enters the scene tree for the first time.
func _ready():
	init_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_main():
	z_index = 80
	call_deferred("drop_out")


func drop_out():
	var r = randi_range(0, 300)
	var d = randi_range(-300, 0)
	var tween_left = create_tween()
	tween_left.tween_property(sprite_2d_left,"position",Vector2(position.x - r, 1000), 1.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween_left.tween_property(sprite_2d_left,"rotation_degrees",d, 0.8).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween_left.play()
	
	var tween_right = create_tween()
	tween_right.tween_property(sprite_2d_right,"position",Vector2(position.x + r, 1000), 1.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween_right.tween_property(sprite_2d_right,"rotation_degrees",d*(-1), 0.8).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween_right.play()
	await tween_left.finished and tween_right.finished
	queue_free()
	get_parent().queue_free()
