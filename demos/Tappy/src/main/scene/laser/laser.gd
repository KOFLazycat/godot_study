extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func set_collision_disabled() -> void:
	collision_shape_2d.set_deferred("disabled", true)
