extends RigidBody2D


var size=Vector2(320,78)
var word_width=48

func _ready():
#	physics_material_override.friction=0
	pass


func setChar(word:String):
	if word=="w":
		$Bg.region_rect=Rect2(12,22,44,37)
		$Bg.flip_v=true
	elif word=='s':
		$Bg.region_rect=Rect2(101,21,34,39)
	elif word=='e':
		$Bg.region_rect=Rect2(57,21,38,40)
		$Bg.flip_v=true
		$Bg.flip_h=true
	

