extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var hero = $Hero
@onready var game_over = $GameOver
@onready var timer = $Timer

@onready var monster_tscn = preload("res://src/main/scene/level/bomb_hero/monster.tscn")
@onready var bomb_tscn = preload("res://src/main/scene/level/bomb_hero/bomb.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1)
	game_over.hide()
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var progress = randi()%3934
	path_follow_2d.set_progress(progress)
	print(path_follow_2d.position)
	var monster = monster_tscn.instantiate()
	monster.spawn(hero, path_follow_2d.global_position)
	add_child(monster)
	
	var bomb = bomb_tscn.instantiate()
	bomb.spawn(hero.position)
	add_child(bomb)


func _on_hero_game_over():
	game_over.show()
	get_tree().paused = true
