extends Node2D

@onready var timer = $Timer
@onready var little_man = $LittleMan


var meteorolite = preload("res://src/main/scene/level/basic_animation/meteorolite.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.g_hp_value <= 0:
		Global.g_hp_value = 100


func _on_timer_timeout():
	var m = meteorolite.instantiate()
	var r_x = randf_range(0.0, 960.0)
	m.set_velocity(little_man.global_position, Vector2(r_x, -100))
	add_child(m)
