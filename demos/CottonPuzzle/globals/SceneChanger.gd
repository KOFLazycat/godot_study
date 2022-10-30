extends CanvasLayer
@onready var color_rect = $ColorRect

func _ready():
	change_scene("")
	pass


func change_scene(path: String):
	var tween = create_tween()
	tween.tween_callback(color_rect.show)
	tween.tween_property(color_rect, "color:a", 1.0, 0.2)
	tween.tween_callback(get_tree().change_scene_to_file.bind(path))
	tween.tween_property(color_rect, "color:a", 0.0, 0.3)
	tween.tween_callback(color_rect.hide)
	

