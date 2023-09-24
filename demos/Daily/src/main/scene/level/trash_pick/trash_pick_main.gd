extends Node2D

@onready var box: Sprite2D = $Box
@onready var food: Sprite2D = $Food
@onready var animation_player_box: AnimationPlayer = $Box/AnimationPlayer
@onready var animation_player_food: AnimationPlayer = $Food/AnimationPlayer


var speed: float = 200.0
var total_time: float = 0.0
var dragging: bool = false:
	set(val):
		dragging = val
		if dragging:
			animation_player_food.play("RESET")
		else:
			animation_player_food.play("shake")
var consume_data: Node2D:
	set(val):
		consume_data = val
		if consume_data:
			animation_player_box.play("shake")
		else:
			animation_player_box.play("RESET")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	total_time += delta
	if !dragging and food:
		food.global_position.x += sin(total_time) * speed * delta


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click") and DragMgr.pick_data == null:
		# 进入拖拽状态
		dragging = true
		DragMgr.start_pick(food)


func _on_area_2d_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("click") and consume_data:
		# 销毁对象
		consume_data = null
		dragging = false
		animation_player_box.play("stretch")


func _on_area_2d_box_mouse_entered() -> void:
	if DragMgr.pick_data and DragMgr.pick_data.is_in_group("food"):
		consume_data = DragMgr.pick_data


func _on_area_2d_box_mouse_exited() -> void:
	if consume_data:
		consume_data = null
