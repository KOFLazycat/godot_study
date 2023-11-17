extends ColorRect

var tween: Tween


func _ready() -> void:
	pass


func bounce(force: float) -> void:
	var value = remap(1 - force, 0, 1, 22.5, 27.5)
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(material, "shader_parameter/size_scale", value, 0.15).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(material, "shader_parameter/size_scale", 30, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
