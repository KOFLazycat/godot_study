extends Node

@onready var player_stats: Stats = $PlayerStats


func change_scene(path: String, entry_point: String) -> void:
	var tree: SceneTree = get_tree()
	tree.change_scene_to_file(path)
	await tree.tree_changed
	
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position, node.direction)
			break
