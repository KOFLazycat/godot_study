extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


var speed = 200
var velocity = Vector2.ZERO

signal game_over


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	position += velocity.normalized() * speed * delta

	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.stop()


func _on_area_2d_area_entered(area):
	if area.is_in_group("monster"):
		emit_signal("game_over")
