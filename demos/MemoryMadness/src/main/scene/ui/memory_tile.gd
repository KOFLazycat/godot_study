extends TextureButton
class_name MemoryTile

@onready var memory_tile: TextureButton = $"."
@onready var frame_image: TextureRect = $FrameImage
@onready var item_image: TextureRect = $ItemImage

var _item_name: String
var _can_select_me: bool = true


func _ready() -> void:
	memory_tile.pressed.connect(on_memory_tile_pressed)
	SignalManager.selection_enabled.connect(on_selection_enabled)
	SignalManager.selection_disabled.connect(on_selection_disabled)


func get_item_name() -> String:
	return _item_name


func reveal(r: bool) -> void:
	frame_image.visible = r
	item_image.visible = r


func setup(ii_dict: Dictionary, fi: CompressedTexture2D) -> void:
	frame_image.texture = fi
	item_image.texture = ii_dict.item_texture
	_item_name = ii_dict.item_name
	reveal(false)


func kill_on_success() -> void:
	z_index = 1
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "disabled", true, 0)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)
	tween.tween_property(self, "rotation", deg_to_rad(720), 0.5)
	tween.set_parallel(false)
	tween.tween_interval(0.6)
	tween.tween_property(self, "scale", Vector2(0, 0), 0.1)


func on_memory_tile_pressed() -> void:
	if _can_select_me == true:
		SignalManager.tile_selected.emit(self)


func on_selection_enabled() -> void:
	_can_select_me = true


func on_selection_disabled() -> void:
	_can_select_me = false
