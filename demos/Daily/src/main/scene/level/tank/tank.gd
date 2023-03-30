extends Node2D

@onready var sprite_2d_base = $Area2D/Sprite2DBase
@onready var sprite_2d_barrel = $Area2D/Sprite2DBarrel
@onready var camera_2d = $Camera2D
@onready var marker_2d = $Area2D/Sprite2DBarrel/Marker2D
@onready var blood = $Blood


var dir = 1
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_2d.limit_left = 0
	camera_2d.limit_right = 960*2
	camera_2d.limit_top = 0
	camera_2d.limit_bottom = 720


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += dir * speed * delta
	sprite_2d_barrel.look_at(get_global_mouse_position())


func _on_area_2d_area_entered(area):
	if area.is_in_group("handrail"):
		dir = dir * (-1)
		sprite_2d_base.flip_h = !sprite_2d_base.flip_h
#		sprite_2d_barrel.rotation_degrees += 180
	if area.is_in_group("missile"):
		blood.hp_value -= 10
		if blood.hp_value <= 0:
			blood.hp_value = 100
