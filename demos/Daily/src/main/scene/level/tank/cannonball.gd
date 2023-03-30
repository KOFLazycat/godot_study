extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer

var speed = 1000
var velocity = Vector2.ZERO
var dir = Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	

func shoot(_dir, _pos):
	position = _pos
	rotation = _dir.angle()
	velocity = _dir * speed
	timer.start(0.3)


func dead():
	speed = 0
	velocity = Vector2.ZERO
	timer.stop()
	sprite_2d.hide()
	animated_sprite_2d.show()
	animated_sprite_2d.play("explosion")


func _on_timer_timeout():
	dead()


func _on_area_2d_area_entered(area):
	if area.is_in_group("missile"):
		dead()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
