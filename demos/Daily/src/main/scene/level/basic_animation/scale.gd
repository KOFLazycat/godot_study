extends Sprite2D

var scale_speed = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.x += scale_speed
	scale.y += scale_speed
	if scale.x > 3 or scale.x < 0.5:
		scale_speed *= -1
