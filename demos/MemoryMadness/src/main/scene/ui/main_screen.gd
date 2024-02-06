extends Control

@export var level_button_scene: PackedScene

@onready var hb_levels: HBoxContainer = $VBoxContainer/HBLevels


func _ready() -> void:
	setup_grid()


func create_level_button(ln: int) -> void:
	var new_lb: TextureButton = level_button_scene.instantiate()
	hb_levels.add_child(new_lb)
	new_lb.set_level_number(ln)


func setup_grid() -> void:
	for level in GameManager.LEVELS:
		create_level_button(level)
