extends Node2D

@onready var player = $Player


var rotation_speed = 5
var r = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left"):
		var tween = create_tween()
		r = rotation_degrees + rotation_speed
		tween.tween_property(self,"rotation_degrees",r, 0.03).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.play()
	if Input.is_action_pressed("right"):
		var tween = create_tween()
		r = rotation_degrees - rotation_speed
		tween.tween_property(self,"rotation_degrees",r, 0.03).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.play()


func _on_area_2d_area_entered(area):
	pass # Replace with function body.
