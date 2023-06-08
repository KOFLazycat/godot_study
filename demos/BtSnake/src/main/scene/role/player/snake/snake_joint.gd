class_name SnakeJoint
extends DampedSpringJoint2D


@onready var line_2d: Line2D = $Line2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var node1 := get_node( node_a ) as Node2D
	var node2 := get_node( node_b ) as Node2D

	if is_instance_valid( node1 ) and is_instance_valid( node2 ):
		line_2d.set_point_position( 0, node1.global_position )
		line_2d.set_point_position( 1, node2.global_position )
