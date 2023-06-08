class_name SnakeBody
extends RigidBody2D


enum BodySize {
	NORMAL,
	BIG,
}

@export var body_size: BodySize = BodySize.NORMAL:
	set( value ):
		if body_size != value:
			body_size = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match body_size:
		BodySize.NORMAL:
			$Sprite2D.set_deferred("scale", Vector2(1.2, 1.2))
			$CollisionShape2DNormal.set_deferred("disabled", false )
			$CollisionShape2DNormal.set_deferred("visible", true )
			$CollisionShape2DBig.set_deferred("disabled", true )
			$CollisionShape2DBig.set_deferred("visible", false )
			mass = 0.01
		BodySize.BIG:
			$Sprite2D.set_deferred("scale", Vector2(1.5, 1.5))
			$CollisionShape2DNormal.set_deferred("disabled", true )
			$CollisionShape2DNormal.set_deferred("visible", false )
			$CollisionShape2DBig.set_deferred("disabled", false )
			$CollisionShape2DBig.set_deferred("visible", true )
			mass = 0.025
