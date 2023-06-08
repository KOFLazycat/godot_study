extends Node


const food_scene = preload("res://src/main/scene/role/food/food.tscn")
# Propability that big food is spawned (0..1)
const BIG_FOOD_PROPABILITY: float = 0.5

@export var food_count: int = 5

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D as ShapeCast2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# spawn food if needed
	
	var food_nodes = get_tree().get_nodes_in_group("food")
	var food_diff = food_count - food_nodes.size()
	
	if food_diff > 0:
		for i in food_diff:
			_spawn_food()


func _spawn_food() -> void:
	var food_size = Food.FoodSize.NORMAL if randf() > BIG_FOOD_PROPABILITY else Food.FoodSize.BIG

	# Try to find an unoccluded location for spawning food.
	shape_cast_2d.shape.radius = Food.COLLISION_RADIUS_NORMAL if food_size == Food.FoodSize.NORMAL else Food.COLLISION_RADIUS_BIG
	# For immediate shape cast we are supposed to set target_position to 0,0
	shape_cast_2d.target_position = Vector2.ZERO

	# Don't try too often to prevent lags. If not successful this time, then maybe next frame.
	for i in 100:
		shape_cast_2d.position = Vector2( randf_range( 0, 1920 ), randf_range( 0, 1080 ) )
		shape_cast_2d.force_shapecast_update()

		if not shape_cast_2d.is_colliding():
			var food = food_scene.instantiate()
			food.position = shape_cast_2d.position
			food.food_size = food_size
			get_parent().add_child( food )
			break
