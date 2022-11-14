extends SubViewport

@onready var camera = $Camera
var barbHouse = preload("res://scenes/ui/MiniMapSprites/BarrackSprite.tscn")
var unit = preload("res://scenes/ui/MiniMapSprites/ArthaxSprite.tscn")
var tree = preload("res://scenes/ui/MiniMapSprites/TreeSprite.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	updateMap()


func updateMap():
	for i in get_child_count() - 3:
		get_child(i+3).queue_free()
	
	for i in get_node("Units").get_child_count():
		get_node("Units").get_child(i).queue_free()
	
	var housePath = get_tree().get_root().get_node("World/Houses")
	var unitsPath = get_tree().get_root().get_node("World/Units")
	var objectsPath = get_tree().get_root().get_node("World/Objects")

	for i in housePath.get_child_count():
		var house = barbHouse.instantiate()
		add_child(house)
		house.position = housePath.get_child(i).position/2
	
	for i in unitsPath.get_child_count():
		var unitOne = unit.instantiate()
		get_node("Units").add_child(unitOne)
	
	for i in objectsPath.get_child_count():
		var treeOne = tree.instantiate()
		add_child(treeOne)
		treeOne.position = objectsPath.get_child(i).position/2


func _process(delta):
	var cameraPath = get_tree().get_root().get_node("World/Camera")
	var unitsPath = get_tree().get_root().get_node("World/Units")
	camera.position = cameraPath.position/2
	camera.zoom = cameraPath.zoom/2
	
	var unitsTotal = get_node("Units")
	for i in unitsPath.get_child_count():
		if unitsTotal.get_child(i) != null:
			unitsTotal.get_child(i).position = unitsPath.get_child(i).position/2
