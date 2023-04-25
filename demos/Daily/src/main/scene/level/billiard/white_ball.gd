extends RigidBody2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var force: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO
const  FORCE: float = 2000.0


func _physics_process(_delta: float) -> void:
	position.x = clampf(position.x, 70.0, 890.0)
	position.y = clampf(position.y, 157.0, 563.0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		dir = (global_position - get_global_mouse_position()).normalized()
		force = dir * FORCE
		apply_central_impulse(force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("table"):
		audio_stream_player_2d.playing = true
