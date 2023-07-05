extends Area2D
### 攻击对方的范围判定

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

# 碰撞伤害
@export var damage: float = 1.0
# 可以穿越敌人的次数
@export var damage_num: int = 1
# 伤害触发冷却时间
@export var disable_interval: float = 0.4


func temp_disable():
	collision.call_deferred("set","disabled",true)
	if disable_timer.is_stopped():
		disable_timer.start(disable_interval)


func set_damage(dam: float) -> void:
	damage = dam
	
	
func hit(dr: int) -> void:
	if damage_num > 0:
		damage_num -= dr


func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set","disabled",false)
