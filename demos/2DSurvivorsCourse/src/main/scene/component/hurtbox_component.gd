class_name HurtboxComponent
extends Area2D

@export var health_component: Node


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	if !is_instance_valid(health_component):
		return
	var hitbox_component = area as HitboxComponent
	health_component.damage(hitbox_component.damage)
