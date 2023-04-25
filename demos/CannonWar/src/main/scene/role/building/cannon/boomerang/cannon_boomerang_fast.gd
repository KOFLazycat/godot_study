extends CharacterBody2D


## 回旋镖炮塔
@onready var cannon: CharacterBody2D = $"."
@onready var tower: Sprite2D = $Tower
@onready var marker_2d: Marker2D = $Tower/Marker2D
@onready var attack_interval_timer: Timer = $AttackIntervalTimer
@onready var blood: Node2D = $Blood
@onready var attack_range_collision_shape_2d: CollisionShape2D = $Area2DAttackRange/CollisionShape2D

@onready var bullet_tscn = preload("res://src/main/scene/role/bullet/bullet_stick.tscn")


# 攻击范围
@export var attack_range: int = 200
# 子弹速度
@export var bullet_speed: int = 100
# 子弹最多穿透敌人数量
@export var bullet_blood: int = 10
# 子弹伤害
@export var bullet_damage: int = 10
# 子弹模型大小缩放
@export var bullet_scale: float = 0.5
# 炮塔最大血量
@export var cannon_blood_max: int = 120
# 攻击间隔时间
@export var attack_interval: float = 5
# 炮塔价格
@export var price: int = 190
# 炮塔介绍
@export var info: String = "一种威力不小的攻击东西，回旋镖能够穿过敌人，对所有穿过的敌人造成伤害"

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
	init()


# 初始化
func init() -> void:
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
