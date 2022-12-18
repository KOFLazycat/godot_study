extends Area2D
class_name CommonHitBox


@export var damage = 10
@export var collision_mask_init = 0
@export var collision_layer_init = 2

func _init():
	collision_mask = collision_mask_init
	collision_layer = collision_layer_init
