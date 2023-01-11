extends Node2D


@onready var tip_1 = $Tip1
@onready var tip_2 = $Tip2

var time=0
var change=false

func _ready():
	pass # Replace with function body.


func _process(delta):
	queue_redraw()


func _draw():
	var v1 = tip_1.position
	draw_line(Vector2(v1.x-50,0),Vector2(v1.x-50,v1.y)
				,Game.lineColor[0],0.5,true)	
	draw_line(Vector2(v1.x+50,0),Vector2(v1.x+50,v1.y)
				,Game.lineColor[0],0.5,true)
	
	var v2 = tip_2.position
	draw_line(Vector2(v2.x-50,0),Vector2(v2.x-50,v2.y)
				,Game.lineColor[0],0.5,true)	
	draw_line(Vector2(v2.x+50,0),Vector2(v2.x+50,v2.y)
				,Game.lineColor[0],0.5,true)
