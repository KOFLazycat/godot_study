class_name Missile
extends Node2D

@onready var common_hit_box = $CommonHitBox
@onready var enemy_detector = $EnemyDetector

const LAUNCH_SPEED := 1800.0

@export var lifetime := 10.0

var max_speed := 500.0
var drag_factor := 0.15
var _target: EnemyThing2
var _current_velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	common_hit_box.connect("body_entered", Callable(self, "_on_HitBox_body_entered"))
	# Detects a target to lock on within a large radius.
	enemy_detector.connect("body_entered", Callable(self, "_on_EnemyDetector_body_entered"))
	
	var timer := get_tree().create_timer(lifetime)
	timer.connect("timeout", Callable(self, "queue_free"))
	_current_velocity = max_speed * 5 * Vector2.RIGHT.rotated(rotation)


func _physics_process(delta):
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	
	if _target:
		direction = global_position.direction_to(_target.global_position)
	var desired_velocity := direction * max_speed
	var change = (desired_velocity - _current_velocity) * drag_factor
	
	_current_velocity += change
	
	position += _current_velocity * delta
	look_at(global_position + _current_velocity)


func _on_HitBox_body_entered(enemy: EnemyThing2):
	print(enemy)
	queue_free()


func _on_EnemyDetector_body_entered(enemy: EnemyThing2):
	if _target != null:
		return
	if enemy == null:
		return
	_target = enemy

