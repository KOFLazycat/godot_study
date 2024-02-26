extends CanvasLayer

const SAVE_PATH: String = "user://data.sav"

@onready var player_stats: Stats = $PlayerStats
@onready var color_rect: ColorRect = $ColorRect

# 场景名称 => {
# 	enemies_alive => [ 敌人的路径 ]
# }
var world_stats: Dictionary = {}


func _ready() -> void:
	color_rect.color.a = 0


func change_scene(path: String, params: Dictionary = {}) -> void:
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
	
	if "init" in params:
		params.init.call()
	
	await tree.tree_changed
	
	var new_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
	if new_name in world_stats:
		tree.current_scene.from_dict(world_stats[new_name])
	
	if "entry_point" in params:
		for node in tree.get_nodes_in_group("entry_points"):
			if node.name == params.entry_point:
				tree.current_scene.update_player(node.global_position, node.direction)
				break
	elif "position" in params and "direction" in params:
		tree.current_scene.update_player(params.position, params.direction)
		
	
	## 转场之后恢复游戏
	tree.paused = false
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await tween.finished


func save_game() -> void:
	var scene: Node = get_tree().current_scene
	var scene_name: String = scene.scene_file_path.get_file().get_basename()
	world_stats[scene_name] = scene.to_dict()
	
	var data: Dictionary = {
		"world_stats": world_stats,
		"stats": player_stats.to_dict(),
		"scene": scene.scene_file_path,
		"player": {
			"direction": scene.player.direction,
			"position": {
				"x": scene.player.global_position.x,
				"y": scene.player.global_position.y,
			},
		}
	}
	
	var json: String = JSON.stringify(data)
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		return
	file.store_string(json)
	file.close()


func load_game() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json: String = file.get_as_text()
	file.close()
	
	var data: Dictionary = JSON.parse_string(json) as Dictionary
	
	
	change_scene(data.scene, {
		"direction": data.player.direction,
		"position": Vector2(
			data.player.position.x,
			data.player.position.y,
		),
		"init": func():
			world_stats = data.world_stats
			player_stats.from_dict(data.stats)
	})


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		load_game()













