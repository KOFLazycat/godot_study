extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var player_ant: PlayerAnt = $PlayerAnt
@onready var enemy_ant_scene: PackedScene = preload("res://enemy_ant.tscn")

const MAX_ENEMY_COUNT: int = 50
var total_enemy_num: int = 0

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func _on_spawn_timer_timeout() -> void:
	for i in range(10):
		var enemy_ant: EnemyAnt = enemy_ant_scene.instantiate()
		enemy_ant.global_position = Vector2(300, 180)
		enemy_ant.player = player_ant
		add_child(enemy_ant)
		total_enemy_num += 1
		if total_enemy_num >= MAX_ENEMY_COUNT:
			spawn_timer.stop()
			break
	
	
