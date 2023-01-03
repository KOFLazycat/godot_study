extends StaticBody2D


var width=376	#地面的宽度
var state=Game.slow	#状态
var fastSpeed=120	
var slowSpeed=40


func _ready():
	add_to_group(Game.group_ground)
	
	
func _physics_process(delta):
	if state==Game.slow:
		if position.x<-width:
			position.x=width-3
		position.x-=slowSpeed*delta
	elif state==Game.fast:
		if position.x<-width:
			position.x=width-3
		position.x-=fastSpeed*delta
	elif state==Game.stop:
		pass
	

func setState(newState):
	state=newState
