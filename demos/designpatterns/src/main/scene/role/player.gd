extends CharacterBody2D
class_name Player

## 移动速度
@export var speed: float = 200.0
## 最大冲刺时间
@export var max_sprint_time: float = 3.0

@onready var state_machine: StateMachine = $StateMachine
@onready var attack_system: AttackSystem = $AttackSystem
@onready var health_system: HealthSystem = $HealthSystem

## 移动方向
var dir: Vector2 = Vector2.ZERO :
	get:
		return Input.get_vector("left", "right", "up", "down")

## 冲刺剩余时间
var sprint_time: float:
	set(v):
		sprint_time = v
		if sprint_time <= 0:
			sprint_time = 0

## 冲刺状态
var is_sprint: bool:
	get:
		return Input.is_action_just_pressed("sprint")



func _physics_process(delta: float) -> void:
	
	move_and_slide()
