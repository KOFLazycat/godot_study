extends Control

@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	color_rect.material.set_shader_parameter("value", 0.0)
	
	var tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/value", 1.0, 10.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


func _process(delta: float) -> void:
	var mouse_pos = color_rect.get_global_mouse_position()
	color_rect.material.set_shader_parameter("iMouse", Color(mouse_pos.x/1920, mouse_pos.y/1080, 0.0, 0.0))
