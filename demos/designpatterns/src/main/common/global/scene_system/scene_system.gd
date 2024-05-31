extends CanvasLayer

@export var scenes: Array[PackedScene]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel: Panel = $Panel


## 方便访问场景的枚举
enum SCENE_INDEX {
	TEST_AUDIO,
	TEST_SCENE,
	TEST_WORLD
}

var pre_scene: PackedScene
var cur_scene: PackedScene


func load_new_scene(scene_index: SCENE_INDEX) -> void:
	animation_player.play("tran_in")
	await animation_player.animation_finished
	cur_scene = scenes[scene_index]
	get_tree().change_scene_to_packed(cur_scene)
	animation_player.play("tran_out")


func set_old_scene(scene_index: SCENE_INDEX) -> void:
	cur_scene = scenes[scene_index]










