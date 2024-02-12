extends Node

const GROUP_TILE: String = "tile"

const LEVELS: Dictionary = {
	1: { "rows": 2, "cols": 2 },
	2: { "rows": 3, "cols": 4 },
	3: { "rows": 4, "cols": 4 },
	4: { "rows": 4, "cols": 6 },
	5: { "rows": 5, "cols": 6 },
	6: { "rows": 6, "cols": 6 }
}


func get_level_selection(level_num: int) -> Dictionary:
	var l_data = LEVELS[level_num]
	var num_tiles = l_data.rows * l_data.cols
	var target_pairs: int = num_tiles / 2
	var selected_level_images: Array = []
	
	ImageManager.shuffle_images()
	
	for i in range(target_pairs):
		selected_level_images.append(ImageManager.get_image(i))
		selected_level_images.append(ImageManager.get_image(i))
	
	selected_level_images.shuffle()
	return {
		"target_pairs": target_pairs,
		"num_rows": l_data.rows,
		"num_cols": l_data.cols,
		"image_list": selected_level_images
	}


func clear_nodes_of_group(g_name: String) -> void:
	for n in get_tree().get_nodes_in_group(g_name):
		n.queue_free()
