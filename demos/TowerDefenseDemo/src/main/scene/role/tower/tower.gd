extends StaticBody2D


@onready var base: Sprite2D = $Base
@onready var cannon: Sprite2D = $Cannon
@onready var timer: Timer = $Timer
@onready var marker_2d: Marker2D = $Cannon/Marker2D


@onready var base_texture_1 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile183.png")
@onready var base_texture_2 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile180.png")
@onready var tower_texture_1 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile249.png")
@onready var tower_texture_2 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile250.png")
@onready var missile_tscn = preload("res://src/main/scene/role/missile/missile.tscn")

@export var tower_id: int = 1
@export var fire_intval_time: float = 1.0

var tower_map: Dictionary = {}
var tower_offset_x: int = 22
var target_array: Array = []
var is_set_up: bool = false
# 放置炮塔时如果有重叠的炮台会将其放置该数组
var overlapping_obj_array: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower_map[1] = [base_texture_1, tower_texture_1]
	tower_map[2] = [base_texture_2, tower_texture_2]
	# 每秒发射一次导弹
	timer.start(fire_intval_time)
	set_tower_id()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target_array.size() > 0:
		cannon.look_at(target_array[0].global_position)
		for i in target_array:
			if i == null:
				print("NULL")


func set_tower_id() -> void:
	if tower_map.has(tower_id):
		base.texture = tower_map[tower_id][0]
		cannon.texture = tower_map[tower_id][1]
		cannon.offset.x = tower_offset_x


func set_up_done() -> void:
	is_set_up = true


func _on_timer_timeout() -> void:
	if is_set_up and target_array.size() > 0:
		var missile = missile_tscn.instantiate()
		missile.fire(marker_2d.global_position, target_array[0])
		var parent = get_parent()
		if parent != null:
			parent.add_child(missile)
		else:
			add_child(missile)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		target_array.append(area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		target_array.erase(area)


# 用来判断是否与其他炮塔重合
func _on_area_2d_tower_area_entered(area: Area2D) -> void:
	if area.is_in_group("area_tower"):
		overlapping_obj_array.append(area)


func _on_area_2d_tower_area_exited(area: Area2D) -> void:
	if area.is_in_group("area_tower"):
		overlapping_obj_array.erase(area)
