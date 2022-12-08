extends Node2D


@export var speed = 1000.0
var direction := Vector2.ZERO


func _ready():
	set_as_top_level(true)
	look_at(position + direction)


func _physics_process(delta: float):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
