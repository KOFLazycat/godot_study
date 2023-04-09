extends Node2D
## 基础炮塔
@onready var cannon: Node2D = $"."
@onready var tower: Sprite2D = $Tower
@onready var marker_2d: Marker2D = $Tower/Marker2D
@onready var attack_interval_timer: Timer = $AttackIntervalTimer
@onready var blood: Node2D = $Blood
@onready var area_2d_attack_range: Area2D = $Area2DAttackRange
@onready var attack_range_collision_shape_2d: CollisionShape2D = $Area2DAttackRange/CollisionShape2D
@onready var base_camp = get_parent().get_node("BaseCamp")

@onready var bullet_tscn = preload("res://src/main/scene/role/bullet/bullet.tscn")


# 攻击范围
@export var attack_range: int = 300
# 子弹速度
@export var bullet_speed: int = 100
# 炮塔最大血量
@export var cannon_blood_max: int = 100
# 攻击间隔时间
@export var attack_interval_time: float = 1.0
# 炮塔价格
@export var price: int = 50
# 炮塔介绍
@export var info: String

# 炮塔当前血量
var cannon_blood: int = 0
# 炮塔等级
var cannon_lvl: int = 1
# 炮塔可攻击对象数组
var target_arr: Array = []
# 炮塔当前击对象
var current_target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cannon_blood = cannon_blood_max
	blood.blood_max = cannon_blood
	attack_interval_timer.start(attack_interval_time)
	attack_range_collision_shape_2d.shape.radius = attack_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_attack_interval_timer_timeout() -> void:
	if !target_arr.has(base_camp):
		target_arr.append(base_camp)
	if target_arr.size() or true:
		var bullet = bullet_tscn.instantiate()
		bullet.position = marker_2d.position
		bullet.speed = bullet_speed
		bullet.blood = 1
		bullet.fire(target_arr)
		add_child(bullet)


func _on_area_2d_attack_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("monster"):
		target_arr.append(area)


func _on_area_2d_attack_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("monster"):
		target_arr.erase(area)


func _on_area_2d_take_damage_range_area_entered(_area: Area2D) -> void:
	pass # Replace with function body.



