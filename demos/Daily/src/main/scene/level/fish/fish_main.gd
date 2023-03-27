extends Node2D

@onready var timer = $Timer
@onready var little_fish = preload("res://src/main/scene/level/fish/little_fish.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(3)
	timer.autostart = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var l_fish = little_fish.instantiate()
	add_child(l_fish)
