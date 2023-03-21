extends Node2D

@onready var rigid_body_2d = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rigid_body_2d.linear_velocity = Vector2(180, 0)
	pass
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("pipe"):
		queue_free()
