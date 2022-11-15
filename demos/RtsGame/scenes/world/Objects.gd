extends Node2D


@onready var tree = preload("res://scenes/objects/Tree.tscn")
@onready var coinHouse = preload("res://scenes/houses/CoinHouse.tscn")

var tile_size = 16
var grid_size = Vector2(160, 160)
var grid = []
enum {OBSTACTLE, COLLECTIABLE, RESOURCE}

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			
	var positions = []
	for i in range(50):
		var xcoor = (randi()%int(grid_size.x))
		var ycoor = (randi()%int(grid_size.y))
		var grid_pos = Vector2(xcoor, ycoor)
		if grid_pos not in positions:
			positions.append(grid_pos)
		
	for pos in positions:
		var new_tree = tree.instantiate()
		new_tree.position = tile_size*pos
		grid[pos.x][pos.y] = OBSTACTLE
		add_child(new_tree)

func _input(event):
	if event.is_action_pressed("LeftClick"):
		var mouse_pos = get_global_mouse_position()
		var multiX = int(round(mouse_pos.x)/tile_size)
		var multiY = int(round(mouse_pos.y)/tile_size)
		var numX = multiX*tile_size
		var numY = multiY*tile_size
		var new_pos = Vector2(multiX, multiY)
		
		var around = false
		for i in range(tile_size):
			if grid[new_pos.x - 1][new_pos.y] !=null or grid[new_pos.x + 1][new_pos.y] !=null or grid[new_pos.x][new_pos.y - 1] !=null or grid[new_pos.x][new_pos.y + 1] !=null:
				around = true
		if grid[new_pos.x][new_pos.y] == null:
			if !around:
				var new_coin_house = coinHouse.instantiate()
				new_coin_house.position = tile_size*new_pos
				grid[new_pos.x][new_pos.y] = RESOURCE
				add_child(new_coin_house)
			else:
				print("Alread Has Building Near It")
		

