extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	physics_material_override.friction = 1


#设置颜色
func setColor(color:String):
	$Ball.modulate=Color(color)
