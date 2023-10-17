extends Node


@export var sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player:CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	var sword_insance: Node2D = sword_ability.instantiate() as Node2D
	if !is_instance_valid(player) or !is_instance_valid(sword_insance):
		return
	player.get_parent().add_child(sword_insance)
	sword_insance.global_position = player.global_position
