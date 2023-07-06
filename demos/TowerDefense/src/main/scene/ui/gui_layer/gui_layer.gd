extends CanvasLayer

@onready var label_fps: Label = $GameInfo/LabelFps
@onready var h_flow_container_magic: HFlowContainer = $FlowContainer/HFlowContainerMagic
@onready var h_flow_container_tower: HFlowContainer = $FlowContainer/HFlowContainerTower
@onready var btn_add_magic: Button = $TestBtn/BtnAddMagic
@onready var label_coin: Label = $GameInfo/LabelCoin


const item_tscn := preload("res://src/main/scene/ui/gui_layer/item.tscn") as PackedScene

enum ItemType {
	MAGIC,
	TOWER,
}

@export var items_magic: Array[Texture] = []
var current_item_magic := 0
@export var items_tower: Array[Texture] = []
var current_item_tower := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	btn_add_magic.pressed.connect(_add_item.bind(ItemType.MAGIC))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_fps.text = "FPS:" + str(Engine.get_frames_per_second())
	label_coin.text = str(Global.get_total_coin())


func _on_btn_add_magic_pressed() -> void:
	_add_item(ItemType.MAGIC)


func _on_btn_add_tower_pressed() -> void:
	_add_item(ItemType.TOWER)


func _on_btn_remove_magic_pressed() -> void:
	_remove_item(ItemType.MAGIC)


func _on_btn_remove_tower_pressed() -> void:
	_remove_item(ItemType.TOWER)


# 添加物品
func _add_item(item_type: int) -> void:
	var item = item_tscn.instantiate()
	match item_type:
		ItemType.MAGIC:
			item.set_deferred("texture", items_magic[current_item_magic])
			current_item_magic = (current_item_magic + 1) % items_magic.size()
			h_flow_container_magic.add_child(item)
		ItemType.TOWER:
			item.set_deferred("texture", items_tower[current_item_tower])
			current_item_tower = (current_item_tower + 1) % items_tower.size()
			h_flow_container_tower.add_child(item)
	
	# Ensures the animation plays as the container resets the scale otherwise
	await get_tree().process_frame
	var tween :=  create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	item.scale = Vector2.ZERO
	tween.tween_property(item, "scale", Vector2.ONE, 0.3)


func _remove_item(item_type: int) -> void:
	var h_flow_container: HFlowContainer = null
	match item_type:
		ItemType.MAGIC:
			h_flow_container = h_flow_container_magic
		ItemType.TOWER:
			h_flow_container = h_flow_container_tower
	if h_flow_container.get_child_count() > 0:
		var last = h_flow_container.get_child(h_flow_container.get_child_count() - 1)
		if last:
			h_flow_container.remove_child(last)
