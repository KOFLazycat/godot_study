extends Node2D

@export var speed: float = 200.0

@onready var player: CharacterBody2D = $Player
@onready var button: Button = $TestUI/VBoxContainer/Button
@onready var button_2: Button = $TestUI/VBoxContainer/Button2

var dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	if LoadSaveSystem.is_load:
		LoadSaveSystem.load(player)


func _physics_process(delta: float) -> void:
	var iv: Vector2 = Input.get_vector("left", "right", "up", "down")
	if iv:
		dir = iv
		player.velocity = dir * speed
	else :
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.y = move_toward(player.velocity.y, 0, speed)
	player.move_and_slide()


## 返回主界面
func _on_button_pressed() -> void:
	SceneSystem.set_old_scene(SceneSystem.SCENE_INDEX.TEST_AUDIO)
	SceneSystem.load_new_scene(SceneSystem.SCENE_INDEX.TEST_SCENE)


## 存档
func _on_button_2_pressed() -> void:
	LoadSaveSystem.save(player)
