extends Node2D


var score_dot = preload("res://src/main/scene/role/score/score_dot.tscn")
var colorList=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
#	init(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()


func init(num):
	for i in range(10):
		var temp = score_dot.instantiate()
		temp.position.x = 70+i*18+randf_range(-0.1,0.1)
		#temp.position.x = 70+i*18
		temp.position.y=-5
		temp.name=str("score_dot",i)
	#	temp.setColor(Game.blockColor[5])
		if i<num:
			temp.setColor("#fdfbc8")
		else:
			temp.setColor("#ffa195")
		add_child(temp)	
		var joint= DampedSpringJoint2D.new()
		joint.name=str("joint2D",i)
		joint.length=30
		joint.rest_length=4
		joint.stiffness=10
		joint.damping=0.4
		joint.position.x=70+i*18
		joint.position.y=0
		#joint.node_a=NodePath("../top")
		joint.node_a=$Top.get_path()
		joint.node_b=temp.get_path()
		#joint.node_b=NodePath(str("../",temp.name))
		#joint.node_b=NodePath(str("../dots/",temp.name))
		
		colorList.append(temp)
		add_child(joint)


func clear():
	for i in get_children():
		if 'score_dot' in i.name or 'joint2D' in i.name:
			remove_child(i)
	colorList.clear()


func _draw():
	for i in range(len(colorList)):
		draw_line(Vector2(70+i*18,0),colorList[i].position,Game.lineColor[0],0.5,true)
		
		
