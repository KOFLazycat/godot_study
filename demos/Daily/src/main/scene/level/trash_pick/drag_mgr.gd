extends Node2D

# 拖拽对象
var pick_data: Node2D
# 第一次鼠标点击位置与精灵位置之间的差值
var d_value: Vector2


func _ready() -> void:
	set_process(false)
	set_process_input(false)


func _process(delta: float) -> void:
	pick_data.global_position = get_global_mouse_position() - d_value


func start_pick(p_pick_data: Node2D) -> void:
	pick_data = p_pick_data
	pick_data.top_level = true
	d_value = get_global_mouse_position() - pick_data.global_position
	set_process(true)
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		# 释放对象
		pick_data.top_level = false
		pick_data.get_parent().dragging = false
		pick_data = null
		set_process(false)
		set_process_input(false)
