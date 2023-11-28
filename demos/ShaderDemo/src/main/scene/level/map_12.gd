extends Control

@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/iTime", 1.0, 10.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
