extends Node2D

@onready var tail_gas = $TailGas
@onready var sprite_2d = $Sprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D


var speed = 500
var velocity = Vector2.ZERO
var target = null
var steer_force = 100
var acc = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		var desired = (target.global_position - global_position).normalized()*speed
		var steer = (desired - velocity).normalized()*steer_force
		acc += steer
		velocity += acc * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
	position += velocity * delta


func fire(player):
	target = player
	position.x = randi_range(player.global_position.x - 500, player.global_position.x + 500)
	position.y = randi_range(player.global_position.y - 500, player.global_position.y + 500)
	$Timer.start(4)
	

func dead():
	speed = 0
	velocity = Vector2.ZERO
	$Timer.stop()
	sprite_2d.hide()
	tail_gas.hide()
	animated_sprite_2d.show()
	animated_sprite_2d.play("explosion")


func _on_timer_timeout():
	dead()


func _on_area_2d_area_entered(area):
	dead()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
