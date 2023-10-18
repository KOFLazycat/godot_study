extends CharacterBody2D


const MAX_SPEED: float = 75


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction: Vector2 = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if is_instance_valid(player):
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO


func on_area_entered(area: Area2D) -> void:
	queue_free()
