extends CharacterBody2D

const MAX_SPEED: float = 50

@onready var health_component: Node = $HealthComponent
@onready var visuals: Node2D = $Visuals
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	var direction: Vector2 = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if is_instance_valid(player):
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO

