extends Node

@onready var spawn = preload("res://global/SpawnUnit.tscn")

var Wood:int = 0
var Coin:int = 0
var hasSpawn:bool = false

func spawnUnit(pos):
	var uiPath = get_tree().get_root().get_node("World/UI")
	var hasSpawn:bool = false
	for i in uiPath.get_child_count():
		if "SpawnUnit" in uiPath.get_child(i).name:
			hasSpawn = true
			break
	if !hasSpawn:
		var spawnUnit = spawn.instantiate()
		spawnUnit.housePos = pos
		uiPath.add_child(spawnUnit)
