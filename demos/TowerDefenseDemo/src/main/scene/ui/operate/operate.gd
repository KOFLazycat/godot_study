extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_operate_btn_upgrade_pressed() -> void:
	print("_on_operate_btn_upgrade_pressed")


func _on_operate_btn_repair_pressed() -> void:
	print("_on_operate_btn_repair_pressed")


func _on_operate_btn_destory_pressed() -> void:
	var parent = get_parent()
	Global.g_tower_arr.erase(parent)
	parent.queue_free()
	
