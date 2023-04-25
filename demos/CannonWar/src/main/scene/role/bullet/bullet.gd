extends Area2D

# 回旋镖子弹
@onready var sprite_bullet: Sprite2D = $SpriteBullet
@onready var ani_explosion: AnimatedSprite2D = $AniExplosion
@onready var ani_bullet: AnimationPlayer = $AniBullet
@onready var life_timer: Timer = $LifeTimer
@onready var audio_fire: AudioStreamPlayer = $AudioFire
@onready var audio_explosion: AudioStreamPlayer = $AudioExplosion


signal remove_from_array(obj)

# 子弹存活最长时间
@export var life_time: float = 10
# 子弹血量，用于确定子弹可以穿透敌人的数量
@export var blood: int = 1

# 子弹速度
var speed: int = 10
# 子弹伤害，威力
var damage: int = 10
# 子弹转向力
var steer_force: int = 30
# 子弹加速度
var acc: Vector2 = Vector2.ZERO
var target_arr: Array = []
var temp = null
var velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	sprite_bullet.show()
	ani_bullet.play("rolling")
	ani_explosion.hide()
	life_timer.start(life_time)
	audio_fire.play()


func _physics_process(delta: float) -> void:
	if target_arr.size():
		var desired = (target_arr.front().global_position - global_position).normalized()*speed
		var steer = (desired - velocity).normalized()*steer_force
		acc += steer
		velocity += acc * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity*delta
	else:
		queue_free()


func dead() -> void:
	speed = 0
	velocity = Vector2.ZERO
	life_timer.stop()
	sprite_bullet.hide()
	ani_bullet.stop()
	ani_explosion.show()
	ani_explosion.play("explosion")
	audio_explosion.play()
	emit_signal("remove_from_array", self)
	await ani_explosion.animation_finished and audio_explosion.finished
	queue_free()


func fire(tar: Array) -> void:
	if tar.size() > 0:
		target_arr = tar


func hit(blood_reduce: int = 1) -> void:
	blood -= blood_reduce
	if blood <= 0:
		dead()


func _on_life_timer_timeout() -> void:
	dead()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	dead()
