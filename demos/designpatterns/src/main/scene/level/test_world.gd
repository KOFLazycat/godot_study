extends Node2D

@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var button: Button = $TestUI/VBoxContainer/Button
@onready var button_2: Button = $TestUI/VBoxContainer/Button2
@onready var player_health_bar: ProgressBar = %PlayerHealthBar


func _ready() -> void:
	# 玩家生命变化信号连接
	player.health_system.health_update.connect(_on_player_health_system_health_update)
	
	if LoadSaveSystem.is_load:
		LoadSaveSystem.load(player)


## 返回主界面
func _on_button_pressed() -> void:
	SceneSystem.set_old_scene(SceneSystem.SCENE_INDEX.TEST_AUDIO)
	SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_SCENE)


## 存档
func _on_button_2_pressed() -> void:
	LoadSaveSystem.save(player)


func _on_player_health_system_health_update(health: float, max_health: float) -> void:
	var v: float = remap(health, 0, max_health, player_health_bar.min_value, player_health_bar.max_value)
	var tween: Tween = create_tween()
	tween.tween_property(player_health_bar, "value", v, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
