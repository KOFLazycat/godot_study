extends Node2D

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var monster_spawn_timer: Timer = $MonsterSpawnTimer
@onready var base_camp: CharacterBody2D = $BaseCamp

@onready var monster_tscn = preload("res://src/main/scene/role/enemy/monster/monster.tscn")

# 怪物生成间隔时间
@export var monster_spawn_interval: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster_spawn_timer.start(monster_spawn_interval)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_monster_spawn_timer_timeout() -> void:
#	print(Time.get_time_string_from_system())
	var monster = monster_tscn.instantiate()
	path_follow_2d.set_progress_ratio(randf())
	add_child(monster)
	monster.spawn(path_follow_2d.position, base_camp)
