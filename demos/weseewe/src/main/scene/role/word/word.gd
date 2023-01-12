extends Node2D

@onready var top = $Top

var _chars = preload("res://src/main/scene/role/word/char.tscn")
var charList = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	init()
	pass # Replace with function body.


func _process(delta):
	queue_redraw()
	

func init():
	var chars = ['w', 'e', 's', 'e', 'e', 'w', 'e']
	for i in range(7):
		var temp = _chars.instantiate()
		temp.position.x = 40+i*40+randf_range(-0.2,0.2)
		temp.position.y=-30
		temp.name=str("char",i)
		temp.setChar(chars[i])

		add_child(temp)
		var joint = DampedSpringJoint2D.new()
		joint.name = str("joint2D", i)
		joint.length = 60
		joint.rest_length = 4
		joint.stiffness = 8
		joint.damping = 0.5
		joint.position.x = 40 + i * 40
		joint.position.y = -30
		joint.node_a = top.get_path()
		joint.node_b = temp.get_path()

		add_child(joint)
		charList.append(temp)


func clear():
	for i in get_children():
		if 'char' in i.name or 'joint2D' in i.name:
			remove_child(i)
	charList.clear()


func _draw():
	for i in range(len(charList)):
		draw_line(Vector2(40 + i * 40, 0), charList[i].position, Game.lineColor[0], 0.5, true)
