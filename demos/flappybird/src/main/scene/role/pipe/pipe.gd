extends StaticBody2D

#地面的高度
const GROUND_HEIGHT = 125
const OFFSET_Y      = 110
const PIPE_WIDTH    = 52 #水管长度
const OFFSET_X      = 130 #每个水管相距的位置
  
#signal scoreChange	#分数变化

#状态
var state=Game.stop
var speed=110	#速度

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_to_group(Game.group_pipe)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state==Game.stop:
		pass
	elif state==Game.move:
	#	constant_linear_velocity = Vector2(-10,0)
		position.x-=speed*delta
		if position.x<-PIPE_WIDTH:
			#当最后一个水管坐标-PIPE_WIDTH时在屏幕外 放到最一根的后面 每个水管的距离是PIPE_WIDTH+OFFSET_X
			position.x=(PIPE_WIDTH+OFFSET_X)*3-PIPE_WIDTH
			setRandomYpos()


func setState(newState):
	state=newState
	

#设置随机的y坐标 	
func setRandomYpos():
	position.y=randi_range(OFFSET_Y,Game.winHeight-GROUND_HEIGHT-OFFSET_Y)


func _on_area_2d_body_entered(body):
	#print("_on_area_2d_body_entered")
	if body.is_in_group(Game.group_bird):
		Game.emit_signal("scoreChange")
