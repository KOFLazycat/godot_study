extends Node

@export var anvil_ability_scene: PackedScene

@onready var timer: Timer = $Timer

const BASE_RANGE: float = 100
const BASE_DAMAGE: float = 15


func _ready() -> void:
	timer.timeout.connect(on_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !is_instance_valid(player):
		return
		
	var direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = player.global_position + (direction * randf_range(0, BASE_RANGE))
	
	# player collision mask, 使用位运算来检查某个位是否为1，更简单直观
	var query_paramaters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
	var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
	
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability_instance = anvil_ability_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability_instance)
	anvil_ability_instance.global_position = spawn_position
	anvil_ability_instance.hitbox_component.damage = BASE_DAMAGE


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"anvil":
			timer.autostart = true
			timer.start()
