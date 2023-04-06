extends Node2D

@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#func get_my_path(start_pos: Vector2, end_pos: Vector2) -> void:
#	var my_path = Navigation2DServer.map_get_path(start_pos, end_pos)
