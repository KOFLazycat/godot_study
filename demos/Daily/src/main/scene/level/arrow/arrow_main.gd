extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var arrow_tscn = preload("res://src/main/scene/level/arrow/arrow.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		fire()


func fire() -> void:
	var num: int = randi_range(2, 6)
	for i in range(num):
		var arrow = arrow_tscn.instantiate()
		arrow.global_position = player.global_position
		add_child(arrow)
