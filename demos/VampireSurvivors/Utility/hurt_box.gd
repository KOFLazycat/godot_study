extends Area2D


@export_enum("Cooldown", "HitOnce", "DisableHitBox") var hurt_box_type = 0
@onready var collision_shape_2d = $CollisionShape2D
@onready var disable_timer = $DisableTimer

signal hurt(damage)


func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match hurt_box_type:
				0:#Cooldown
					collision_shape_2d.set_deferred("disabled", true)
					disable_timer.start()
				1:#HitOnce
					pass
				2:#DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt", damage)


func _on_disable_timer_timeout():
	collision_shape_2d.set_deferred("disabled", false)
