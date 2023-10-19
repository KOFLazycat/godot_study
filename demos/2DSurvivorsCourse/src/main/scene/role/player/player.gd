extends CharacterBody2D


const MAX_SPEED: float = 150.0
const ACCELERATION_SMOOTHING = 25.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = get_movement_vector()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1.0 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()
