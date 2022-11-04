extends Node2D
@onready var sprite_2d = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var blue_value = 0.3
	sprite_2d.get_material().set_shader_parameter("blue", blue_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
