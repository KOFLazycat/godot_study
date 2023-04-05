extends Button

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var repair_texture = preload("res://src/main/assets/texture/icon/operate/towerDefense_tile016.png")
@onready var destroy_texture = preload("res://src/main/assets/texture/icon/operate/towerDefense_tile017.png")
@onready var upgrade_texture = preload("res://src/main/assets/texture/icon/operate/towerDefense_tile018.png")

@export var operate_id: int = 1

var operate_map : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.scale = Vector2(0.45, 0.45)
	sprite_2d.position = Vector2(25, 25)
	operate_map[1] = upgrade_texture
	operate_map[2] = repair_texture
	operate_map[3] = destroy_texture
	set_operate_id()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_operate_id() -> void:
	sprite_2d.texture = operate_map[operate_id]
