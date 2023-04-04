extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


@export var missile_live_time: int = 2
@export var missile_damage: int = -30

var speed: int = 150
var steer_force: int = 30
var acc: Vector2 = Vector2.ZERO
var target = null
var temp = null

func _ready() -> void:
	timer.start(missile_live_time)
	animated_sprite_2d.hide()
	sprite_2d.show()


func _physics_process(delta: float) -> void:
	if target != null:
		var desired = (target.global_position - global_position).normalized()*speed
		var steer = (desired - velocity).normalized()*steer_force
		acc += steer
		velocity += acc * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity*delta
	else:
		dead()


func _on_timer_timeout() -> void:
	dead()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func dead() -> void:
	speed = 0
	velocity = Vector2.ZERO
	timer.stop()
	sprite_2d.hide()
	animated_sprite_2d.show()
	animated_sprite_2d.play("explosion")


func fire(_pos: Vector2, _tar) -> void:
	position = _pos
	target = _tar


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		dead()
