extends CharacterBody2D
## 基础炮塔
@onready var cannon: CharacterBody2D = $"."
@onready var tower: Sprite2D = $Tower
@onready var marker_2d: Marker2D = $Tower/Marker2D
@onready var attack_interval_timer: Timer = $AttackIntervalTimer
@onready var blood: Node2D = $Blood
@onready var attack_range_collision_shape_2d: CollisionShape2D = $Area2DAttackRange/CollisionShape2D

@onready var bullet_tscn = preload("res://src/main/scene/role/bullet/bullet.tscn")


# 攻击范围
@export var attack_range: int = 300
# 子弹速度
@export var bullet_speed: int = 1000
# 子弹最多穿透敌人数量
@export var bullet_blood: int = 1
# 子弹伤害
@export var bullet_damage: int = 10
# 子弹模型大小缩放
@export var bullet_scale: float = 1.0
# 炮塔最大血量
@export var cannon_blood_max: int = 100
# 攻击间隔时间
@export var attack_interval: float = 1.0
# 炮塔价格
@export var price: int = 50
# 炮塔介绍
@export var info: String = "最基础的炮塔，想获得厉害的炮塔就要从它开始进化，但是基础炮塔不太能无限获取，获取基础炮塔越多，需要的费用就越贵。"

# 炮塔当前血量
var cannon_blood: int = 0
# 炮塔等级
var cannon_lvl: int = 1
# 炮塔可攻击对象数组
var target_arr: Array = []
# 炮塔当前攻击对象
var current_target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cannon_blood = cannon_blood_max
	blood.blood_max = cannon_blood
	blood.init()
	attack_interval_timer.start(attack_interval)
	attack_range_collision_shape_2d.shape.radius = attack_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_attack_interval_timer_timeout() -> void:
	if target_arr.size():
		var bullet = bullet_tscn.instantiate()
		bullet.position = marker_2d.position
		bullet.speed = bullet_speed
		bullet.blood = bullet_blood
		bullet.damage = bullet_damage
		bullet.fire(target_arr)
		add_child(bullet)


func _on_area_2d_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("monster") and not target_arr.has(body):
		target_arr.append(body)


func _on_area_2d_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("monster") and target_arr.has(body):
		target_arr.erase(body)
