extends Sprite2D


@export var gravity=40
@export var ySpeed=1400	#y轴飞行速度
@export var xSpeed=200	#x偏移
@export var rotateSpeed=40	#旋转速度	
@export var dropSpeed=10
@export var dropXSpeed=0	#下落之后的x速度
@export var rgb= Color(0,0,0)

var angle = 0 #角度
var vec=Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready():
	vec.y=-ySpeed
	vec.x=xSpeed
	modulate=rgb
	$Timer.connect("timeout", Callable(self, "_on_timeout"))
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vec.y>0:
		vec.y=dropSpeed
		vec.x=dropXSpeed
	else:
		vec.y+=gravity
	
	angle+=rotateSpeed*delta
	rotation_degrees=round(angle)	
	if angle>360 or angle<-360:
		angle=0
	position+=vec*delta


func _on_timeout():
	queue_free()

