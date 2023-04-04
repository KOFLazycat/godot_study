extends Node2D

@onready var timer: Timer = $Timer
@onready var path_lvl_1_tscn = preload("res://src/main/scene/level/path/lvl_1/path_lvl_1.tscn")

@export var interval_time : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(interval_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var path_lvl_1 = path_lvl_1_tscn.instantiate()
	add_child(path_lvl_1)
