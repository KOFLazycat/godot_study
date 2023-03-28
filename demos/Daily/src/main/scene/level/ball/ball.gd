extends Node2D


var speed = 300
var velocity = Vector2.ZERO
var acc = Vector2.ZERO

signal hit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acc = velocity.normalized() * 100
	velocity += acc * delta
	position += velocity *delta


func _on_area_2d_area_entered(area):
	if area.is_in_group("board"):
		emit_signal("hit")
	
	if area.is_in_group("fence"):
		get_tree().reload_current_scene()


func bounce(dir):
	var m_dir = dir
	m_dir += randf_range(-PI/3, PI/3)
	rotation = m_dir
	velocity = Vector2(1, 0).rotated(m_dir) * speed
