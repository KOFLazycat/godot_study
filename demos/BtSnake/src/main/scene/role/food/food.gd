class_name Food
extends RigidBody2D


enum FoodSize {
	NORMAL,
	BIG,
}

const COLLISION_RADIUS_NORMAL: float = 10.0
const COLLISION_RADIUS_BIG: float = 20.0

@export var food_size: FoodSize = FoodSize.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Coin.play("rotate")
	match food_size:
		FoodSize.NORMAL:
			$Coin.set_deferred("scale", Vector2(2, 2))
			$CollisionShape2DNormal.set_deferred("disabled", false )
			$CollisionShape2DNormal.set_deferred("visible", true )
			$CollisionShape2DBig.set_deferred("disabled", true )
			$CollisionShape2DBig.set_deferred("visible", false )
		FoodSize.BIG:
			$Coin.set_deferred("scale", Vector2(4, 4))
			$CollisionShape2DNormal.set_deferred("disabled", true )
			$CollisionShape2DNormal.set_deferred("visible", false )
			$CollisionShape2DBig.set_deferred("disabled", false )
			$CollisionShape2DBig.set_deferred("visible", true )


