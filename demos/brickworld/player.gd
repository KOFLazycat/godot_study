extends CharacterBody2D

@export var EXPLOSION_FORCE: float = 500.0


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	pass


func get_forward_direciton() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())


func update_trajectory() -> void:
	velocity = EXPLOSION_FORCE * get_forward_direciton()
	var line_start: Vector2 = global_position
	var line_end: Vector2 = Vector2.ZERO
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var damp: float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
	var timestep: float = 0.02
	var colors: Array[Color] = [Color.RED, Color.YELLOW]
	
	for i:int in 70:
		velocity.y += gravity * timestep
		line_end = line_start + velocity * timestep
		velocity = velocity * clampf(1.0 - damp * timestep, 0, 1)
		
		var ray := raycast_query2d(line_start, line_start)
		
		if not ray.is_empty():
			break
		draw_line_global(line_start, line_end, colors[i%2])
		line_start = line_end


func raycast_query2d(pointA: Vector2, pointB: Vector2) -> Dictionary:
	var space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(pointA, pointB, 1)
	var result:Dictionary = space_state.intersect_ray(query)
	
	if result:
		return result
	else:
		return {}


func draw_line_global(pointA: Vector2, pointB: Vector2, color: Color, width: int = -1) -> void:
	var local_offset: Vector2 = pointA - global_position
	var pointB_local: Vector2 = pointB - global_position
	draw_line(local_offset, pointB_local, color, width)













