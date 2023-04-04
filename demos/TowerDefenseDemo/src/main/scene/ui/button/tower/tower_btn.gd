extends Button

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var tower_texture_1 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile249.png")
@onready var tower_texture_2 = preload("res://src/main/assets/texture/role/tower/towerDefense_tile250.png")

@export var tower_id: int = 1

var tower_map : Dictionary = {}

signal add_tower(tower_id)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("add_tower", Callable(get_tree().get_first_node_in_group("main"), "handle_add_tower"))
	sprite_2d.scale = Vector2(0.45, 0.45)
	sprite_2d.position = Vector2(30, 30)
	tower_map[1] = tower_texture_1
	tower_map[2] = tower_texture_2
	set_tower_id()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	emit_signal("add_tower", tower_id)
	

func set_tower_id() -> void:
	sprite_2d.texture = tower_map[tower_id]
