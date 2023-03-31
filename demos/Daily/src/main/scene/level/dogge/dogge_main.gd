extends Node2D


@onready var mon_timer = $MonTimer
@onready var player = $Player
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var monster = preload("res://src/main/scene/level/dogge/monster.tscn")
@onready var hud = $HUD


# Called when the node enters the scene tree for the first time.
func _ready():
	
	player.position = Vector2(480, 360)
	player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mon_timer_timeout():
	var mon = monster.instantiate()
	# 3355 是 progress 100%的最大值
	path_follow_2d.set_progress(randi()%3355)
	add_child(mon)
	var dir = (player.position - path_follow_2d.position).normalized()
	mon.spawn(dir, path_follow_2d.position)


func _on_hud_game_start():
	hud.info_label.hide()
	hud.start_button.hide()
	player.show()
	mon_timer.start(1)


func _on_player_game_over():
	get_tree().call_group("monster", "queue_free")
	get_tree().reload_current_scene()
