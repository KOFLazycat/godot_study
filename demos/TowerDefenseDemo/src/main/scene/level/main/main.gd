extends Node2D

@onready var tower_tscn = preload("res://src/main/scene/role/tower/tower.tscn")

var tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if tower != null:
		tower.position = get_global_mouse_position()


func handle_add_tower(tower_id) -> void:
	tower = tower_tscn.instantiate()
	tower.tower_id = tower_id
	tower.set_tower_id()
	tower.modulate.a8 = 180
	add_child(tower)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and tower != null:
		# 放置炮塔
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			tower.modulate.a8 = 255
			tower.set_up_done()
			for i in tower.get_children():
				if i.is_in_group("attack_range_panel"):
					i.visible = false
					break
			tower = null
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			tower.queue_free()
