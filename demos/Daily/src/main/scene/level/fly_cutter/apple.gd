extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var fragment_apple_tscn = preload("res://src/main/scene/level/fly_cutter/fragment_apple.tscn")

var r_speed = 0
var d_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	init_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += r_speed * delta
	if Global.glob_next_flag == true and d_flag == false and r_speed > 0:
		r_speed = 0
		d_flag = true
		call_deferred("drop_out")


func init_main():
	position = Global.GLOB_WOOD_POS
	r_speed = Global.GLOB_ROTATION_SPEED
	rotation_degrees = randi()%360
	z_index = 90
	d_flag = false
	show()


func drop_out():
	r_speed = 0
	rotation_degrees = 0 #270
	var r = randi_range(-300, 300)
	var d = randi_range(-300, 300)
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x + r, 1000), 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"rotation_degrees",d, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("fly_cutter") and Global.glob_next_flag == false:
		rotation_degrees = 0
		r_speed = 0
		sprite_2d.hide()
		Global.glob_score += 1
		call_deferred("spawn_fragment_apple")


func spawn_fragment_apple():
	var fragment_apple = fragment_apple_tscn.instantiate()
	add_child(fragment_apple)
