extends Node

const SPAWN_RADIUS: float = 350.0

@export var basic_enemy_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if !is_instance_valid(player):
		return
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spwan_position: Vector2 = player.global_position + (random_direction * SPAWN_RADIUS)
	var enemy = basic_enemy_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	entities_layer.add_child(enemy)
	enemy.global_position = spwan_position
