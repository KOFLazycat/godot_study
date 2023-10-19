extends Camera2D


var target_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func acquire_target() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	if is_instance_valid(player):
		target_position = player.global_position
