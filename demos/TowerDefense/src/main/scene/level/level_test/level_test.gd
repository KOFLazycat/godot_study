extends Node2D


@onready var invisible_walls = $InvisibleWalls


# Called when the node enters the scene tree for the first time.
func _ready():
	invisible_walls.visible = false
