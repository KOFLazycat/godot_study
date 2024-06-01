extends Area2D
class_name AttackSystem

@export var damage: float

var other_health_system: HealthSystem


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func attack() -> void:
	other_health_system.health -= damage


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("player"):
		other_health_system = body.health_system


func _on_body_exited(body: Node2D) -> void:
	if other_health_system:
		other_health_system = null
