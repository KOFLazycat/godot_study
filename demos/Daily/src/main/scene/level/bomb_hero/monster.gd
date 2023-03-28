extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position.move_toward(target.position, randf_range(10, 100) * delta)


func spawn(_target, _pos):
	target = _target
	position = _pos


func _on_area_2d_area_entered(area):
	queue_free()	
