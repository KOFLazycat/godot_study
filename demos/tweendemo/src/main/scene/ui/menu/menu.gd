class_name Menu
extends Control

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(update_label, 0, 3000, 1.5)


func update_label(new_v: int) -> void:
	label.text = "Score: " + str(new_v)
