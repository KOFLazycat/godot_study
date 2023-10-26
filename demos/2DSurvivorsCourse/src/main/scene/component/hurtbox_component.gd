class_name HurtboxComponent
extends Area2D

@export var health_component: Node

var floating_text_scene: PackedScene = preload("res://src/main/scene/ui/floating_text.tscn")

func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	if !is_instance_valid(health_component):
		return
	var hitbox_component = area as HitboxComponent
	health_component.damage(hitbox_component.damage)

	var floating_text_instance = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text_instance)
	floating_text_instance.global_position = global_position + Vector2.UP * 8
	floating_text_instance.start(str(hitbox_component.damage))
