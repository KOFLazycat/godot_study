extends Node2D

@onready var red_wood = $RedWood
@onready var long_wood = $LongWood
@onready var long_wood_2 = $LongWood2
@onready var long_wood_3 = $LongWood3
@onready var long_wood_4 = $LongWood4
@onready var short_wood = $ShortWood
@onready var short_wood_2 = $ShortWood2
@onready var short_wood_3 = $ShortWood3
@onready var sprite_2d_win = $Sprite2DWin


# Called when the node enters the scene tree for the first time.
func _ready():
	red_wood.init_wood(1, 0, Vector2(288, 310))
	long_wood.init_wood(2, 0, Vector2(333, 125))
	long_wood_2.init_wood(3, -90, Vector2(422, 305))
	long_wood_3.init_wood(4, -90, Vector2(701, 213))
	long_wood_4.init_wood(5, 0, Vector2(333, 583))
	short_wood.init_wood(6, -90, Vector2(248, 450))
	short_wood_2.init_wood(7, 0, Vector2(656, 397))
	short_wood_3.init_wood(8, -90, Vector2(611, 539))
	sprite_2d_win.hide()
	red_wood.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_box_game_win():
	sprite_2d_win.show()
	red_wood.hide()
	await get_tree().create_timer(2).timeout
	sprite_2d_win.hide()
	Global.glob_level = 2
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/second.tscn")
	if err != OK:
		print("Second Stage Loading Error...")


func _on_box_game_reset():
	_ready()
