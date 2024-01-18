extends Control


@onready var score_label: Label = $MarginContainer/ScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.score_update.connect(on_score_update)


func on_score_update() -> void:
	score_label.text = str(Global.get_score())
