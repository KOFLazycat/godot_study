extends CanvasLayer


func _on_button_pressed() -> void:
	AudioSystem.play_bgm(0)


func _on_button_2_pressed() -> void:
	AudioSystem.play_bgm(0)


func _on_button_3_pressed() -> void:
	AudioSystem.play_sfx(randi_range(0, AudioSystem.sfxs.size() - 1))


func _on_return_button_pressed() -> void:
	SceneSystem.set_old_scene(SceneSystem.SCENE_INDEX.TEST_AUDIO)
	SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_SCENE)
