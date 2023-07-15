extends Area2D
### 受到攻击的范围判定

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

# 碰撞类型
@export_enum("Cooldown","HitOnce","DisableHurtBox") var hit_box_type = 0
# 冷却时间
@export var disable_interval: float = 1.0
# 每次消耗子弹次数
@export var blood_reduce: int = 1

signal hurt(damage, angle, knockback)
var hit_once_array: Array = []


func remove_from_list(obj) -> void:
	if hit_once_array.has(obj):
		hit_once_array.erase(obj)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if not (area.get("damage") == null):
			match hit_box_type:
				0: #Cooldown
					collision.call_deferred("set","disabled",true)
					disable_timer.start(disable_interval)
				1: #HitOnce
					if hit_once_array.has(area) == false:
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array", Callable(self, "remove_from_list")):
								area.connect("remove_from_array", Callable(self, "remove_from_list"))
				2: #DisableHurtBox
					if area.has_method("temp_disable"):
						area.temp_disable()
					
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			
			if area.has_method("hit"):
				area.hit(blood_reduce)
			emit_signal("hurt", damage, angle, knockback)


func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false)
