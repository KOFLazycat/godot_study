extends Node2D

@onready var bird = $Bird


func _ready():
	bird.setState(Game.fly)


func _on_start_btn_pressed():
	Game.changeScene(Game.mainScene)
