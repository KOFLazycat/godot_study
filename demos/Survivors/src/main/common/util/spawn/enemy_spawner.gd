extends Node2D

@onready var timer: Timer = $Timer
@onready var player = get_tree().get_first_node_in_group("player")
@export var spawns: Array[SpawnInfo] = []
@export var interval: float = 1.0

@export var time: float = 0

signal change_time(time)

func _ready() -> void:
	connect("change_time", Callable(player, "change_time"))
	timer.start(interval)


func _on_timer_timeout() -> void:
	time += interval
	for i in spawns:
		## 时间区间左闭右开
		if time >= i.time_start and time < i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += interval
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
	emit_signal("change_time", time)


func get_random_position(up: bool = true, down: bool = true, left: bool = true, right: bool = true):
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = []
	if up:
		pos_side.append("up")
	if down:
		pos_side.append("down")
	if right:
		pos_side.append("right")
	if left:
		pos_side.append("left")
	
	var get_rand = randi() % pos_side.size()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side[get_rand]:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = Vector2(bottom_right.x, top_left.y)
		"down":
			spawn_pos1 = Vector2(top_left.x, bottom_right.y)
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = Vector2(bottom_right.x, top_left.y)
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = Vector2(top_left.x, bottom_right.y)
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos2.y, spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
