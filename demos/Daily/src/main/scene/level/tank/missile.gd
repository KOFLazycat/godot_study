extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer

var speed = 400
var velocity = Vector2.ZERO
var target = null
var steer_force = 30
var acc = Vector2.ZERO
var temp = null


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null:
		position.x -= speed * delta
	else:
		var desired = (target.global_position - global_position).normalized()*speed
		var steer = (desired - velocity).normalized()*steer_force
		acc += steer
		velocity += acc * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity*delta
	

func fire(player, fire_pos):
	temp = player
	position = fire_pos
	timer.start(0.5)


func dead():
	speed = 0
	velocity = Vector2.ZERO
	timer.stop()
	sprite_2d.hide()
	animated_sprite_2d.show()
	animated_sprite_2d.play("explosion")


func _on_timer_timeout():
	if timer.wait_time == 4:
		dead()
	if timer.wait_time == 0.5:
		timer.stop()
		target = temp
		sprite_2d.flip_h = true
		timer.start(4)


func _on_area_2d_area_entered(area):
	dead()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
