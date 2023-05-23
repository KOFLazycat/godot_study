extends TextureRect

@onready var item_texture: TextureRect = $ItemTexture
var upgrade = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrade != null:
		item_texture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])

