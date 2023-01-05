extends AnimatedSprite2D


#显示闪光的功能

var OFFSET=44 #偏移的位置

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


#显示闪光
func show():
	visible=true
	play("default")


func setNewPos():
	position.x=randi()%OFFSET
	position.y=randi()%OFFSET


func _on_animation_finished():
	setNewPos()
