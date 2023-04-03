extends Node2D


@onready var base: Sprite2D = $Base
@onready var tower: Sprite2D = $Tower


@onready var base_texture_1 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile183.png")
@onready var base_texture_2 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile180.png")
@onready var tower_texture_1 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile249.png")
@onready var tower_texture_2 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile250.png")

@export var tower_id: int = 1

var tower_map : Dictionary = {}
var tower_offset_y = -22
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower_map[1] = [base_texture_1, tower_texture_1]
	tower_map[2] = [base_texture_2, tower_texture_2]
	set_tower_id()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_tower_id() -> void:
	if tower_map.has(tower_id):
		base.texture = tower_map[tower_id][0]
		tower.texture = tower_map[tower_id][1]
		tower.offset.y = tower_offset_y
