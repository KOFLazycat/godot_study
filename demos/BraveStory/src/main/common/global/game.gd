extends CanvasLayer

@onready var player_stats: Stats = $PlayerStats
@onready var color_rect: ColorRect = $ColorRect

# 场景名称 => {
# 	enemies_alive => [ 敌人的路径 ]
# }
var world_stats: Dictionary = {}


func _ready() -> void:
	color_rect.color.a = 0


func change_scene(path: String, entry_point: String) -> void:
	var tree: SceneTree = get_tree()
	## 转场之前暂停游戏
	tree.paused = true
	
	var tween: Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	var old_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
	world_stats[old_name] = tree.current_scene.to_dict()
	
	tree.change_scene_to_file(path)
	await tree.tree_changed
	
	var new_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
	if new_name in world_stats:
		tree.current_scene.from_dict(world_stats[new_name])
	
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position, node.direction)
			break
	
	## 转场之后恢复游戏
	tree.paused = false
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await tween.finished
