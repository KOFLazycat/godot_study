extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent

const MAX_RADIUS: float = 100
var base_rotation: Vector2 = Vector2.RIGHT


func _ready() -> void:
	# 斧头旋转起始位置增加随机化
	base_rotation = base_rotation.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func tween_method(rotations: float) -> void:
	var percent: float = rotations / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	var player:CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if !is_instance_valid(player):
		return
	global_position = player.global_position + (current_direction * current_radius)
