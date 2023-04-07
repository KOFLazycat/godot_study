extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


var speed: int = 600
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.glob_start_game:
		position += velocity * delta
		rotation_degrees += 10
		

func reset() -> void:
	position = Vector2(480, 320)
	velocity = Vector2.DOWN * speed
	collision_shape_2d.disabled = false
	
	
func bounce(r: float) -> void:
	r += randf_range(-PI/3, PI/3)
	rotation = r
	velocity = Vector2(1, 0).rotated(r)*speed
	

func add_scale():
	scale.x += 0.1
	scale.y += 0.1
	gpu_particles_2d.amount += 0.1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("guard"):
		bounce(-PI/2)
	# 左右上下砖块
	if area.is_in_group("brick_up"):
		bounce(-PI/2)
	if area.is_in_group("brick_down"):
		bounce(PI/2)
	if area.is_in_group("brick_left"):
		bounce(PI)
	if area.is_in_group("brick_right"):
		bounce(0)
	# 左右上围栏
	if area.is_in_group("enclosure_left"):
		bounce(0)
	if area.is_in_group("enclosure_right"):
		bounce(PI)
	if area.is_in_group("enclosure_up"):
		bounce(PI/2)
	if area.is_in_group("enclosure_down"):
		set_deferred("collision_shape_2d.disabled", true)
		call_deferred("reset")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	reset()
