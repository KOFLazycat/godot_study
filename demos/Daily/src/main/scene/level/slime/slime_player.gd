extends Node2D

@onready var player = $Player

signal game_over


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		var tween = create_tween()
		if position.y > 360:
			player.frame = 1
			tween.tween_property(self,"position",Vector2(200, 220), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		else:
			player.frame = 0
			tween.tween_property(self,"position",Vector2(200, 580), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.play()
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("triangle"):
		emit_signal("game_over")
