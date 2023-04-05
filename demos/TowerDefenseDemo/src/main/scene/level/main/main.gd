extends Node2D

@onready var tower_tscn = preload("res://src/main/scene/role/tower/tower.tscn")
@onready var map: Node2D = $Map
@onready var tile_map: TileMap = $Map/TileMap



var tower
# 炮塔可放置距离边界的范围
var tower_margin_x = 50
var tower_margin_y = 50
# 已放置炮塔位置数组
var tower_pos_arr: Array = []
var cur_tile_coord: Vector2i
# 攻击范围圈，绿色
var range_green: Color = Color(0.498039, 1, 0, 0.2)
# 攻击范围圈，红色
var range_red: Color = Color(1, 0, 0, 0.5)
# 默认草地tile坐标
var ground_tile_coord = Vector2i(4, 5)
var is_able_ste_up: bool = false
var viewport_rect_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_rect_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_instance_valid(tower):
		tower.position = get_global_mouse_position()
		is_able_to_set_tower()


# 判断是否可以放置炮塔
func is_able_to_set_tower() -> void:
	is_able_ste_up = true
	# 判断坐标是否在地图范围内
	if tower.position.x >= tower_margin_x and tower.position.x <= (viewport_rect_size.x - tower_margin_x) and tower.position.y >= tower_margin_y and tower.position.y <= (viewport_rect_size.y - tower_margin_y):
		# 判断是否放置在草地上
		var tile = tile_map.local_to_map(tower.position)
		cur_tile_coord = tile_map.get_cell_atlas_coords(0, tile, false)
		if cur_tile_coord == ground_tile_coord:
			# 判断炮塔附近是不是存在重叠的炮塔，如果已经存在，不可以继续放置
			if tower.overlapping_obj_array.size() > 0:
				is_able_ste_up = false
		else:
			is_able_ste_up = false
	else:
		is_able_ste_up = false

	# 设置遮罩颜色
	if is_able_ste_up:
		tower.set_range_color(true, range_green)
	else:
		tower.set_range_color(true, range_red)


func handle_add_tower(tower_id) -> void:
	tower = tower_tscn.instantiate()
	tower.tower_id = tower_id
	tower.set_tower_id()
	tower.modulate.a8 = 180
	add_child(tower)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_instance_valid(tower):
		# 放置炮塔
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT and is_able_ste_up:
			tower.modulate.a8 = 255
			tower.set_up_done()
			# 放置炮塔以后 记录炮塔位置
			tower_pos_arr.append(tower.global_position)
			tower.set_range_color(false, range_green)
			tower = null
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			tower.queue_free()
