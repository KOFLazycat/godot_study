extends Node

const SPAWN_RADIUS: float = 350.0

@onready var timer: Timer = $Timer

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node
var base_spawn_time: float = 0
var enemy_table: WeightedTable = WeightedTable.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_table.add_itme(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !is_instance_valid(player):
		return Vector2.ZERO
	
	var spwan_position: Vector2 = Vector2.ZERO
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:#[0, 1, 2, 3]
		random_direction = random_direction.rotated(i * PI/2)
		spwan_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		# player collision mask, 使用位运算来检查某个位是否为1，更简单直观
		var query_paramaters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(player.global_position, spwan_position, 1 << 0)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		
		if result.is_empty():
			# we are clear
			break
	
	return spwan_position

func on_timer_timeout() -> void:
	timer.start()
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if !is_instance_valid(player):
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_itme(wizard_enemy_scene, 20)
