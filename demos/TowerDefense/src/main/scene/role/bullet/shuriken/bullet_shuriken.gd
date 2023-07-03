extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_life: Timer = $TimerLife


var speed: int = 300
var steer_force: int = 30
var acc: Vector2 = Vector2.ZERO
var target = null
var rotation_offset: float = 0.11
var bullet_life: int = 5

func _ready() -> void:
	timer_life.start(bullet_life)


func _physics_process(delta: float) -> void:
	animated_sprite_2d.rotation += rotation_offset
	if is_instance_valid(target):
		var desired = (target.global_position - global_position).normalized()*speed
		var steer = (desired - velocity).normalized()*steer_force
		acc += steer
		velocity += acc * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity*delta
	else:
		dead()


func _on_timer_life_timeout() -> void:
	dead()


func fire(_pos: Vector2, _tar) -> void:
	position = _pos
	target = _tar


func dead() -> void:
	speed = 0
	velocity = Vector2.ZERO
	timer_life.stop()
	queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		dead()
