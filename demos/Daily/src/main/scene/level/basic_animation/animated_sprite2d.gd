extends AnimatedSprite2D

@onready var animated_sprite_2d = $"."
var move_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animated_sprite_2d.play("fly")
	position.x += move_speed
	if position.x > 1200:
		position.x = -100
