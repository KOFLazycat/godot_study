extends Panel

@onready var texture_button: TextureButton = $TextureButton
@onready var tower_tscn = preload("res://src/main/scene/role/tower/tower.tscn") as PackedScene


var texture: CompressedTexture2D : set = set_texture
var tower: StaticBody2D = null


func _physics_process(_delta: float) -> void:
	if is_instance_valid(tower):
		tower.position = get_global_mouse_position()


func set_texture(new_texture: CompressedTexture2D) -> void:
	texture = new_texture
	texture_button.texture_normal = texture


func _on_texture_button_pressed() -> void:
	if !is_instance_valid(tower):
		tower = tower_tscn.instantiate()
		tower.modulate.a8 = 180
		tower.position = get_global_mouse_position()
		tower.show_attack_range_with_color(true, Tower.AttackRangeColor.GREEN)
		get_tree().root.add_child(tower)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if is_instance_valid(tower):
			# 放置炮塔
			if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
				tower.modulate.a8 = 255
				tower.animated_sprite_2d.play("attack")
				tower.show_attack_range_with_color(false, Tower.AttackRangeColor.GREEN)
				# 放置炮塔以后 记录炮塔位置
				tower = null
			if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
				tower.queue_free()
