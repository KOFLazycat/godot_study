extends Node

@onready var timer: Timer = $Timer

@export var axe_ability_scene: PackedScene
var damage: float = 10


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player:CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	var axe_instance: Node2D = axe_ability_scene.instantiate() as Node2D
	if !is_instance_valid(player) or !is_instance_valid(axe_instance):
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if !is_instance_valid(foreground_layer):
		return
	foreground_layer.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
