extends Area2D


@export var damage = 1
@onready var collision_shape_2d = $CollisionShape2D
@onready var disable_hit_box_timer = $DisableHitBoxTimer


func tempdiable():
	collision_shape_2d.set_deferred("disabled", true)
	disable_hit_box_timer.start()
	

func _on_disable_hit_box_timer_timeout():
	collision_shape_2d.set_deferred("disabled", false)
