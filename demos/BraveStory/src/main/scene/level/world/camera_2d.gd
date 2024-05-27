extends Camera2D

@export var recovery_speed: float = 16.0

var strength: float = 0.0


func _ready() -> void:
	Game.camera_should_shake.connect(on_camera_should_shake)


func _physics_process(delta: float) -> void:
	offset = Vector2(
		randf_range(-strength, strength),
		randf_range(-strength, strength)
	)
	# 逐渐恢复
	strength = move_toward(strength, 0, recovery_speed * delta)


func on_camera_should_shake(amount: float) -> void:
	strength += amount
