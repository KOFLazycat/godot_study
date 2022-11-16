# Allows its owner to detect hits and take damage
class_name HurtBox, "HurtBox.svg"
extends Area2D


func _init():
	# The hurtbox should detect hits but not deal them. This variable does that.
	monitorable = false
	# This turns unchecked collision layer bit 1 and turns checked bit 2. It's the physics layer we reserve to hurtboxes in this demo.
	collision_layer = 2


func _ready() -> void:
	connect("area_entered",Callable(self,"_on_area_entered"))


func _on_area_entered(hitbox: HitBox) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.get_damage())
	if owner.has_method("knock_back"):
		owner.knock_back(hitbox.global_position)
