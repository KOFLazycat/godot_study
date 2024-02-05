extends Node

var _item_images: Array = []
'''
[
	{"item_name": "tree", "item_texture": CompressedTexture2D}
]
'''


func _ready() -> void:
	load_item_images()


func add_file_to_list(fn: String, path: String) -> void:
	var full_path: String = path + "/" + fn
	var ii_dict: Dictionary = {
		"item_name": fn.rstrip(".png"),
		"item_texture": load(full_path)
	}
	_item_images.append(ii_dict)


func load_item_images() -> void:
	var path: String = "res://src/main/assets/glitch/"
	var dir: DirAccess = DirAccess.open(path)
	
	if dir == null:
		print("Error: ", DirAccess.get_open_error())
		return
	
	var file_names: PackedStringArray = dir.get_files()
	
	for fn in file_names:
		if ".import" not in fn:
			add_file_to_list(fn, path)
	print("loaded: ", _item_images.size())
