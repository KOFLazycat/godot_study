extends CharacterBody2D

## 基础怪物
@onready var monster: CharacterBody2D = $"."
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var marker_2d: Marker2D = $Sprite2D/Marker2D
@onready var blood: Node2D = $Blood
@onready var hurtbox: Area2D = $Hurtbox
@onready var hurtbox_collision_shape_2d: CollisionShape2D = $Hurtbox/CollisionShape2D

# 攻击范围
@export var monster_attack_range: int = 50
# 怪物移动速度
@export var monster_speed: float = 10.0
# 怪物碰撞伤害
@export var monster_collide_damage: float = 10.0
# 怪物移动加速度
@export var monster_speed_acc: float = 0.0
# 怪物最大血量
@export var monster_blood_max: int = 100
# 怪物死亡掉落金币
@export var monster_value: int = 5
# 怪物介绍
@export var info: String = "Running Man!!"

# 怪物当前血量
var monster_blood: int = 0
# 怪物等级
var monster_lvl: int = 1
# 怪物冲刺目标数组，有的怪物不需要该数组
var target_arr: Array = []
# 怪物当前攻击对象
var current_target = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster_blood = monster_blood_max
	blood.blood_max = monster_blood
	hurtbox.set_damage(monster_collide_damage)
	hurtbox_collision_shape_2d.shape.radius = monster_attack_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target_arr.size() > 0:
		var dir = (target_arr.back().position - position).normalized()
		velocity = dir * monster_speed
	position += velocity * delta
	move_and_slide()


func spawn(pos, target) -> void:
	position = pos
	if is_instance_valid(target):
		target_arr.append(target)


func death() -> void:
	queue_free()


func _on_hitbox_hurt(damage, angle, knockback) -> void:
	damage = damage * (-1)
	monster_blood += damage
	blood.value_change(damage)
	# 击退效果
#	knockback = angle * knockback_amount
	if monster_blood <= 0:
		death()
	else:
		pass
