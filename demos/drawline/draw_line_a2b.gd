extends Path2D


func _process(delta: float) -> void:
	var mousePos: Vector2 = get_global_mouse_position() - position
	curve.set_point_position(0, Vector2.ZERO)
	var outX: float = mousePos.x / 2
	curve.set_point_out(0, Vector2(outX, -outX))
	
	curve.set_point_position(1, mousePos)
	curve.set_point_out(1, Vector2(-outX, -outX))
