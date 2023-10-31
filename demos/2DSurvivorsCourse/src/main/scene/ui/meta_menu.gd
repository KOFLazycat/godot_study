extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton

var meta_upgrade_card_scene = preload("res://src/main/scene/ui/meta_upgrade_card.tscn") as PackedScene


func _ready() -> void:
	back_button.pressed.connect(on_back_pressed)
	# 方便删除测试节点
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_pressed() -> void:
	ScreenTransition.transition_to_scene("res://src/main/scene/ui/main_menu.tscn")
