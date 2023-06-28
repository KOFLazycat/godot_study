extends Panel

@onready var texture_rect: TextureRect = $TextureRect

var texture: CompressedTexture2D : set = set_texture

func set_texture(new_texture: CompressedTexture2D) -> void:
	texture = new_texture
	texture_rect.texture = texture
