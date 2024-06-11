extends CharacterBody2D
class_name Player

@onready var timer: Timer = $Timer

const SPEED: float = 400.0

var scent_scene: PackedScene = preload("res://scent.tscn")
var scent_array: Array[Scent] = []


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _physics_process(delta: float) -> void:
	var direction: Vector2 = get_movement_vector()
	velocity = direction * SPEED
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()


func _on_timer_timeout() ->void:
	var new_scent: Scent = scent_scene.instantiate()
	new_scent.player = self
	new_scent.global_position = global_position
	new_scent.show_behind_parent = true
	get_parent().add_child(new_scent)
	scent_array.push_front(new_scent)
