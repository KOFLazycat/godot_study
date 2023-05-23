extends Control

var world_tscn = "res://src/main/scene/world/world.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_play_click_end() -> void:
	var world = get_tree().change_scene_to_file(world_tscn)


func _on_btn_exit_click_end() -> void:
	get_tree().quit()
