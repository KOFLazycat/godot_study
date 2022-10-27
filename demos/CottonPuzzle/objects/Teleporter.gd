extends Interactable
class_name Teleporter

@export_file("*.tscn") var target_path: String

func _interact():
	super()
	SceneChanger.change_scene(target_path)

