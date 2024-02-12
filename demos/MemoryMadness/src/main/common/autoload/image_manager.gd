extends Node

const FRAME_IMAGES: Array = [
	preload("res://src/main/assets/frames/blue_frame.png"),
	preload("res://src/main/assets/frames/red_frame.png"),
	preload("res://src/main/assets/frames/yellow_frame.png"),
	preload("res://src/main/assets/frames/green_frame.png"),
]

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


func get_random_item_image() -> Dictionary:
	return _item_images.pick_random()


func get_image(index: int) -> Dictionary:
	return _item_images[index]


func get_random_frame_image() -> CompressedTexture2D:
	return FRAME_IMAGES.pick_random()


func shuffle_images() -> void:
	_item_images.shuffle()
