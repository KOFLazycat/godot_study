extends Control

@onready var score = $Score

func _ready():
	pass

func _process(delta):
	pass

func set_score(new_score: int) -> void:
	score.text = str(new_score)
