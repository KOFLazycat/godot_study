extends Node2D

@export var pipes_scene: PackedScene

@onready var pipes_holder: Node = $PipesHolder
@onready var pipe_upper_pos: Marker2D = $PipeUpperPos
@onready var pipe_lower_pos: Marker2D = $PipeLowerPos
@onready var pipe_spawn_timer: Timer = $PipeSpawnTimer
@onready var plane_cb: CharacterBody2D = $PlaneCB
@onready var game_over: Control = $CanvasLayer/GameOver


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pipe_spawn_timer.timeout.connect(on_pipe_spawn_timer_timeout)
	Global.game_over.connect(on_game_over)
	spawn_pipe()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_pipe() -> void:
	var pos_y = randf_range(pipe_upper_pos.global_position.y, pipe_lower_pos.global_position.y)
	var pipes_instance = pipes_scene.instantiate()
	pipes_instance.global_position = Vector2(pipe_upper_pos.global_position.x, pos_y)
	pipes_holder.add_child(pipes_instance)


func on_pipe_spawn_timer_timeout() -> void:
	spawn_pipe()


func on_game_over() -> void:
	#Global.load_main_scene()
	pass
