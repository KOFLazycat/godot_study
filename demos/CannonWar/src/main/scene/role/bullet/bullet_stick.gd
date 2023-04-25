extends Area2D

# 回旋镖子弹
@onready var sprite_bullet: Sprite2D = $SpriteBullet
@onready var ani_bullet: AnimationPlayer = $AniBullet


signal remove_from_array(obj)


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


func _physics_process(delta: float) -> void:
	if target_arr.size():
#		var desired = (Vector2(960, 525) - global_position).normalized()*speed
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
	sprite_bullet.hide()
	ani_bullet.stop()
	emit_signal("remove_from_array", self)
	queue_free()


func fire(tar: Array) -> void:
	if tar.size() > 0:
		target_arr = tar


func hit(blood_reduce: int = 1) -> void:
	blood -= blood_reduce
	if blood <= 0:
		dead()
