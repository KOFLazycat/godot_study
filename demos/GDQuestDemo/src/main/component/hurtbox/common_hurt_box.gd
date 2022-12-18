extends Area2D
class_name CommonHurtBox


@export var collision_mask_init = 2
@export var collision_layer_init = 0

func _init():
	monitorable = false
	collision_mask = collision_mask_init
	collision_layer = collision_layer_init
	

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	
func _on_area_entered(hitbox: CommonHitBox):
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
