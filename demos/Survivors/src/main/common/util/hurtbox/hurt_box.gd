extends Area2D
## 受到攻击的范围判定

@onready var collision_shape_2d = $CollisionShape2D
@onready var disable_timer = $DisableTimer


# 碰撞类型
@export_enum("Cooldown","HitOnce","DisableHitBox") var hurt_box_type: int = 0
# 伤害触发冷却时间
@export var disable_interval: float = 0.5

var hit_once_array: Array = []

signal hurt(damage: float, knockback_amount: float, angle: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			match hurt_box_type:
				0:
					collision_shape_2d.set_deferred("disabled", true)
					disable_timer.start(disable_interval)
				1:
					if hit_once_array.has(area) == false:
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array",Callable(self, "remove_from_list")):
								area.connect("remove_from_array", Callable(self, "remove_from_list"))
					else:
						return
				2:
					if area.has_method("temp_disable"):
						area.temp_disable()
			
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)
			
			var angle: Vector2 = Vector2.ZERO
			var knockback_amount: float = 1.0
			if area.get("knockback_amount") != null:
				knockback_amount = area.knockback_amount
			if area.get("angle") != null:
				angle = area.angle
			
			emit_signal("hurt", area.damage, knockback_amount, angle)


func remove_from_list(obj) -> void:
	if hit_once_array.has(obj):
		hit_once_array.erase(obj)


func _on_disable_timer_timeout() -> void:
	collision_shape_2d.set_deferred("disabled", false)
