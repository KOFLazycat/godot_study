extends Node2D

@onready var tower_tscn = preload("res://src/main/scene/role/tower/tower.tscn")
@onready var map: Node2D = $Map
@onready var tile_map: TileMap = $Map/TileMap



var tower
var cur_tile_coord: Vector2i
# 默认草地tile坐标
var ground_tile_coord = Vector2i(4, 5)
var is_able_ste_up: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if tower != null:
		tower.position = get_global_mouse_position()
		var tile = tile_map.local_to_map(tower.position)
		cur_tile_coord = tile_map.get_cell_atlas_coords(0, tile, false)
		var pannel = tower.get_node("Panel")
		if cur_tile_coord == ground_tile_coord:
			pannel.modulate = Color8(120, 120, 110, 100)
			is_able_ste_up = true
		else:
			pannel.modulate = Color8(255, 0, 0, 200)
			is_able_ste_up = false


func handle_add_tower(tower_id) -> void:
	tower = tower_tscn.instantiate()
	tower.tower_id = tower_id
	tower.set_tower_id()
	tower.modulate.a8 = 180
	add_child(tower)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and tower != null:
		# 放置炮塔
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT and is_able_ste_up:
			tower.modulate.a8 = 255
			tower.set_up_done()
			var pannel = tower.get_node("Panel")
			if pannel != null:
				pannel.visible = false
			tower = null
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			tower.queue_free()
