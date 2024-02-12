extends TextureButton

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


func on_memory_tile_pressed() -> void:
	if _can_select_me == true:
		reveal(true)


func on_selection_enabled() -> void:
	_can_select_me = true


func on_selection_disabled() -> void:
	_can_select_me = false
