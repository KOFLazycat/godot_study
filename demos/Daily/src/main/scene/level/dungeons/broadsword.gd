extends Sprite2D


@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


var dir: Vector2 = Vector2.ZERO
const SPEED: float = 30.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collision_shape_2d.disabled != false:
		dir = (get_global_mouse_position() - self.global_position).normalized()
		self.rotation = dir.angle()


func stab() -> void:
	self.position += dir * SPEED
	collision_shape_2d.set_deferred("disabled", false)


func reset() -> void:
	self.position -= dir * SPEED
	collision_shape_2d.set_deferred("disabled", true)
