extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var button: Button = $TestUI/VBoxContainer/Button
@onready var button_2: Button = $TestUI/VBoxContainer/Button2


func _ready() -> void:
	if LoadSaveSystem.is_load:
		LoadSaveSystem.load(player)


## 返回主界面
func _on_button_pressed() -> void:
	SceneSystem.set_old_scene(SceneSystem.SCENE_INDEX.TEST_AUDIO)
	SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_SCENE)


## 存档
func _on_button_2_pressed() -> void:
	LoadSaveSystem.save(player)
