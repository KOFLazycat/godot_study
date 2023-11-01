extends Control

@export var health_empty: CompressedTexture2D = preload("res://scenes/ui/health/visuals/HeartEmpty.png")
@export var health_full: CompressedTexture2D = preload("res://scenes/ui/health/visuals/HeartFull.png")

var health: int = 3
@onready var v_box: VBoxContainer = $VBox

func _ready() -> void:
	pass
	
func set_health(new_health) -> void:
	health = new_health
	for i in range(v_box.get_child_count()):
		if i < health:
			v_box.get_child(i).texture = health_full
		else:
			v_box.get_child(i).texture = health_empty
