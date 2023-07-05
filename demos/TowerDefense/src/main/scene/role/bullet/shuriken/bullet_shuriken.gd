extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_life: Timer = $TimerLife
@onready var hurtbox = $Hurtbox

@export var damage: int = 10

# 子弹可以穿越敌人的次数
var bullet_damage_num: int = 1
var speed: int = 300
var steer_force: int = 10
var acc: Vector2 = Vector2.ZERO
var target: Area2D = null
var rotation_offset: float = 0.11
var bullet_life: int = 5

func _ready() -> void:
	hurtbox.damage = damage
	hurtbox.damage_num = bullet_damage_num
	timer_life.start(bullet_life)


func _physics_process(delta: float) -> void:
	animated_sprite_2d.rotation += rotation_offset
	if is_instance_valid(target):
		var desired_v = global_position.direction_to(target.global_position)*speed
		var steer = (desired_v - velocity).normalized()*steer_force
		acc += steer
		velocity += acc * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity*delta
	else:
		dead()


func _on_timer_life_timeout() -> void:
	dead()


func fire(_pos: Vector2, _tar: Area2D) -> void:
	position = _pos
	target = _tar


func dead() -> void:
	speed = 0
	velocity = Vector2.ZERO
	timer_life.stop()
	queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and hurtbox.damage_num == 0:
		dead()
