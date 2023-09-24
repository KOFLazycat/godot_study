extends Node2D

@onready var game_vp: SubViewport = $CanvasLayer/Control/SubViewportContainer/GameVP
@onready var water_vp: SubViewport = $CanvasLayer/Control/SubViewportContainer2/WaterVP


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	water_vp.world_2d = game_vp.world_2d
