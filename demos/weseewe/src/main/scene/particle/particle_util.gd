extends Node2D

@export var num = 30 #粒子数量
@export var pos=Vector2.ZERO	#发射位置
var particle=preload("res://src/main/scene/particle/particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	position=pos
	$Timer.connect("timeout", Callable(self,"_randomParticle"))
#	_randomParticle()
#	addParticle()


func setPos(pos:Vector2):
	position=pos

func addParticle():
	for i in range(num):
		var temp=particle.instantiate()
		temp.gravity+=randi()%30
		temp.dropSpeed+=randi()%30
		var xspeed=randi()%380
		var rotateSpeed = randi()%50
		var dropXSpeed = randi()%40
		if randi()%10>=5:
			temp.xSpeed=xspeed
			temp.rotateSpeed=rotateSpeed
		else:
			temp.xSpeed=-xspeed
			temp.rotateSpeed=-rotateSpeed
		
		if randi()%10>=5:
			temp.dropXSpeed=dropXSpeed
		else:
			temp.dropXSpeed=-dropXSpeed

		temp.rgb=Color(Game.blockColor[randi()%10])
		add_child(temp)


func addRandomPosParticle(pos:Vector2,simpleColor:bool):
	var index=randi()%10
	for i in range(num):
		var temp=particle.instantiate()
		temp.ySpeed=1200
		temp.gravity+=randi()%30
		temp.dropSpeed+=randi()%30
		var xspeed=randi()%180
		var rotateSpeed = randi()%50
		var dropXSpeed = randi()%40
		if randi()%10>=5:
			temp.xSpeed=xspeed
			temp.rotateSpeed=rotateSpeed
		else:
			temp.xSpeed=-xspeed
			temp.rotateSpeed=-rotateSpeed
		
		if randi()%10>=5:
			temp.dropXSpeed=dropXSpeed
		else:
			temp.dropXSpeed=-dropXSpeed
			
		if simpleColor:
			temp.rgb=Color(Game.blockColor[index])
		else:
			temp.rgb=Color(Game.blockColor[randi()%10])
		temp.position=pos
		add_child(temp)



func addEdgeParticle(pos:Vector2,simpleColor:bool):
	var index=randi()%10
	for i in range(num):
		var temp=particle.instantiate()
		temp.ySpeed=1200
		temp.gravity+=randi()%30
		temp.dropSpeed+=randi()%30
		var xspeed=randi()%80
		var rotateSpeed = randi()%50
		var dropXSpeed = randi()%40
		if randi()%10>=5:
			temp.rotateSpeed=rotateSpeed
		else:
			temp.rotateSpeed=-rotateSpeed
		
		if randi()%10>=5:
			temp.dropXSpeed=dropXSpeed
		else:
			temp.dropXSpeed=-dropXSpeed
			
		if simpleColor:
			temp.rgb=Color(Game.blockColor[index])
		else:
			temp.rgb=Color(Game.blockColor[randi()%10])
		temp.position=pos
		add_child(temp)

#添加随机粒子	
func startRandomParticle():
	$Timer.start()

func stopRandomParticle():
	$Timer.stop()
	
	
#随机产生的粒子
func _randomParticle():
	var temp=particle.instantiate()
	temp.position=Vector2(330,30+randi()%300)
	var xspeed=randi()%350+40
	var dropXSpeed = randi()%40+40
	var dropSpeed = randi()%40+30
	temp.ySpeed=0
	temp.xSpeed=-xspeed
	temp.dropXSpeed=-dropXSpeed
	var rotateSpeed = randi()%50
	if randi()%10>=5:
		temp.rotateSpeed=rotateSpeed
	else:
		temp.rotateSpeed=-rotateSpeed
		
	if randi()%10>=5:
		temp.dropSpeed=dropSpeed
	else:
		temp.dropSpeed=-dropSpeed
	temp.rgb=Color(Game.blockColor[randi()%10])
	add_child(temp)
