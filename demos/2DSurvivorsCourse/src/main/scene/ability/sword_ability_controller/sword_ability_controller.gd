extends Node


@export var sword_ability: PackedScene
@export var max_range: float = 150
var damage: float = 5
var base_wait_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout() -> void:
	var player:CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	var sword_insance: Node2D = sword_ability.instantiate() as Node2D
	if !is_instance_valid(player) or !is_instance_valid(sword_insance):
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) <= pow(max_range, 2)
	)
	if enemies.size() <= 0:
		return
	
	enemies.sort_custom(func (a: Node2D, b: Node2D):
		var a_distance: float = a.global_position.distance_squared_to(player.global_position)
		var b_distance: float = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	foreground_layer.add_child(sword_insance)
	
	sword_insance.hitbox_component.damage = damage
	sword_insance.global_position = enemies[0].global_position
	sword_insance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction: Vector2 = enemies[0].global_position - sword_insance.global_position
	sword_insance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != "sword_rate":
		return
	
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	$Timer.start()
