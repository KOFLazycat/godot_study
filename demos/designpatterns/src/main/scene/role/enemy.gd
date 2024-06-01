extends CharacterBody2D
class_name Enemy


@export_category("移动速度")
## 最低移动速度
@export var min_speed: float
## 最高移动速度
@export var max_speed: float

@export_category("待机漫游切换时间")
## 最少待机漫游切换时间
@export var min_idel_and_roam_time: float
## 最多待机漫游切换时间
@export var max_idel_and_roam_time: float

@export_category("攻击间隔")
## 攻击间隔
@export var max_attack_time: float

@export_subgroup("距离设置")
## 进入跟踪范围
@export var follow_distance: float
## 脱离跟踪范围
@export var exit_follow_distance: float
## 进入攻击范围
@export var attack_distance: float
## 脱离攻击范围
@export var exit_attack_distance: float

@onready var attack_system: AttackSystem = $AttackSystem
@onready var health_system: HealthSystem = $HealthSystem

var speed: float
var dir: Vector2
var target: Player
var idel_and_roam_time: float:
	set(v):
		idel_and_roam_time = v
		if idel_and_roam_time <= 0:
			idel_and_roam_time = 0

var attack_time: float:
	set(v):
		attack_time = v
		if attack_time <= 0:
			attack_time = 0


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	move_and_slide()
