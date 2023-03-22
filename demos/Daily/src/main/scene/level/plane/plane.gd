extends Node2D


@onready var timer = $Timer
@onready var player = $Player

var missle = preload("res://src/main/scene/level/plane/missle.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var mis = missle.instantiate()
	mis.fire(player)
	add_child(mis)
