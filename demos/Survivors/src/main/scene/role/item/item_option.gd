extends ColorRect


@onready var player = get_tree().get_first_node_in_group("player")
@onready var label_name: Label = $LabelName
@onready var label_description: Label = $LabelDescription
@onready var label_level: Label = $LabelLevel
@onready var item_icon: TextureRect = $ColorRect/ItemIcon


var mouse_over: bool = false
var item = null

signal selected_upgrade(upgrade)


func _ready() -> void:
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	if item == null:
		item = "food"
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])


func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false


func _input(event: InputEvent) -> void:
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)
