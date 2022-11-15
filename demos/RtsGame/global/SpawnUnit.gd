extends Node2D

@onready var unit = preload("res://scenes/unit/Unit.tscn")
var housePos:Vector2 = Vector2(300, 300)


func _ready():
	print(position)


func _on_yes_pressed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomPosX = rng.randi_range(-50, 50)
	var randomPosY = rng.randi_range(-50, 50)
	
	var unitPath = get_tree().get_root().get_node("World/Units")
	var worldPath = get_tree().get_root().get_node("World")
	var unit1 = unit.instantiate()
	unit1.position = housePos + Vector2(randomPosX, randomPosY)
	unitPath.add_child(unit1)
	worldPath.get_units()
	var minMapPath = get_tree().get_root().get_node("World/UI/MinMap/SubViewportContainer/SubViewport")
	# 加载新单元
	minMapPath._ready()


func _on_no_pressed():
	var housePath = get_tree().get_root().get_node("World/Houses")
	for i in housePath.get_child_count():
		if housePath.get_child(i).is_selected:
			housePath.get_child(i).is_selected = false
	queue_free()
