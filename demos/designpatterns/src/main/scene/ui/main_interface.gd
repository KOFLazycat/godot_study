extends PanelContainer


## 开始游戏 不用加载角色位置
func _on_button_pressed() -> void:
	LoadSaveSystem.is_load = false
	SceneSystem.set_old_scene(SceneSystem.SCENE_INDEX.TEST_SCENE)
	#SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_AUDIO)
	SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_WORLD)


## 继续游戏 需要加载角色位置
func _on_button_2_pressed() -> void:
	LoadSaveSystem.is_load = true
	SceneSystem.set_old_scene(SceneSystem.SCENE_INDEX.TEST_SCENE)
	#SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_AUDIO)
	SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_WORLD)
