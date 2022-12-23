extends Area2D
class_name CommonHitBox


@onready var collision_shape_2d = $CollisionShape2D
@export var damage = 10
@export var collision_mask_init = 4
@export var collision_layer_init = 2

func _init():
	collision_mask = collision_mask_init
	collision_layer = collision_layer_init


func set_disabled(is_disabled: bool):
	collision_shape_2d.set_deferred("disabled", is_disabled)
