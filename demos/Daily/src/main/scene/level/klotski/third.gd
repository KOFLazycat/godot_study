extends Node2D

@onready var red_wood = $RedWood
@onready var long_wood = $LongWood
@onready var long_wood_2 = $LongWood2
@onready var long_wood_3 = $LongWood3
@onready var short_wood = $ShortWood
@onready var short_wood_2 = $ShortWood2
@onready var short_wood_3 = $ShortWood3
@onready var short_wood_4 = $ShortWood4
@onready var sprite_2d_win = $Sprite2DWin

@onready var end_pic = preload("res://src/main/assets/texture/klotski/结束提示.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	red_wood.init_wood(1, 0, Vector2(288, 310))
	long_wood.init_wood(2, 0, Vector2(332, 499))
	long_wood_2.init_wood(3, -90, Vector2(525, 310))
	long_wood_3.init_wood(4, -90, Vector2(620, 310))
	short_wood.init_wood(5, -90, Vector2(249, 169))
	short_wood_2.init_wood(6, 0, Vector2(388, 126))
	short_wood_3.init_wood(7, -90, Vector2(428, 265))
	short_wood_4.init_wood(8, 0, Vector2(568, 126))
	sprite_2d_win.hide()
	red_wood.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_box_game_win():
	sprite_2d_win.texture = end_pic
	sprite_2d_win.show()
	red_wood.hide()
	await get_tree().create_timer(2).timeout
	sprite_2d_win.hide()
	var err = get_tree().change_scene_to_file("res://src/main/scene/level/klotski/klotski_main.tscn")
	if err != OK:
		print("Main Loading Error...")


func _on_box_game_reset():
	_ready()
