extends Area2D
## 攻击对方的范围判定


@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

# 冷却时间
@export var disable_interval: float = 1.0
# 碰撞伤害值
@export var damage: float = 1


func temp_disable() -> void:
	collision.set_deferred("disabled", true)
	disable_timer.start(disable_interval)


func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
