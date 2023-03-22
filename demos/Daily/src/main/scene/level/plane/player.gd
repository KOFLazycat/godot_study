extends Node2D

@onready var player_blood = $PlayerBlood

var life = 100
var damage = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	life = Global.g_hp_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	position = lerp(global_position, get_global_mouse_position(), 0.05)


func _on_area_2d_area_entered(area):
	if area.is_in_group("missle"):
		life -= damage
		if life <= 0:
			life = 100
		Global.g_hp_value = life
