extends RigidBody2D

const EXPLOSION_STRENGTH: float = 1500
const EXPLOSION_MAX_DISTANCE: float = 500
const EXPLOSION_JOINT_SEPARATION_PROPABILITY: float = 0.09

enum ObstacleSize {
	SMALL,
	NORMAL,
}

@export var obstacle_size: ObstacleSize = ObstacleSize.NORMAL:
	set( value ):
		if obstacle_size != value:
			obstacle_size = value


var _explosion_triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	match obstacle_size:
		ObstacleSize.SMALL:
			$AnimatedSprite2D.scale = Vector2(0.8, 0.8)
			$CollisionShape2DSmall.set_deferred("disabled", false )
			$CollisionShape2DSmall.set_deferred("visible", true )
			$CollisionShape2DNormal.set_deferred("disabled", true )
			$CollisionShape2DNormal.set_deferred("visible", false )
		ObstacleSize.NORMAL:
			$AnimatedSprite2D.scale = Vector2(1.5, 1.5)
			$CollisionShape2DSmall.set_deferred("disabled", true )
			$CollisionShape2DSmall.set_deferred("visible", false )
			$CollisionShape2DNormal.set_deferred("disabled", false )
			$CollisionShape2DNormal.set_deferred("visible", true )


func _on_body_entered(body: RigidBody2D) -> void:
	if _explosion_triggered:
		return
		
	if body.is_in_group("snake"):

		# Make sure this obstacle can't be triggered again.
		_explosion_triggered = true
		
		Global.set_game_over()
		
		if obstacle_size == ObstacleSize.SMALL:
			$GPUParticles2DSmall.visible = true	
			$GPUParticles2DSmall.emitting = true	
		else:
			$GPUParticles2DNormal.visible = true
			$GPUParticles2DNormal.emitting = true

		$SndExplosion.play()

		# for safety, code that affects physics should be called deferred
		call_deferred( "_apply_explosion_impulse" )


func _apply_explosion_impulse():
	var max_distance = EXPLOSION_MAX_DISTANCE
	if obstacle_size == ObstacleSize.SMALL:
		max_distance *= 0.66
	
	# Separate joints if linked bodies are under max distance
	
	for node in get_tree().get_nodes_in_group("separable_joint"):
		var joint = node as Joint2D
		var node1 = get_node_or_null( joint.node_a ) as Node2D
		var node2 = get_node_or_null( joint.node_b ) as Node2D

		if node1 and node2:
			var distance1 = node1.global_position - global_position
			var distance2 = node2.global_position - global_position
			if distance1.length() < max_distance or distance2.length() < max_distance:
				if randf() < EXPLOSION_JOINT_SEPARATION_PROPABILITY:
					joint.queue_free()
	
	# Apply explosion impulse to all affectable bodies
	for node in get_tree().get_nodes_in_group("apply_explosion"):
		var body = node as RigidBody2D
		var direction = body.global_position - global_position
		var distance = direction.length()
		
		if distance < max_distance:
			var strength = EXPLOSION_STRENGTH
			if body.is_in_group("snake_head"):
				strength *= 10   # need more strength because head is heavier
#			if obstacle_size == ObstacleSize.SMALL:
#				strength *= 0.66
			body.apply_central_impulse( direction.normalized() * strength / distance )
