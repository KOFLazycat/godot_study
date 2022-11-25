extends Node2D


@onready var level_up = %LevelUp
@onready var upgrade_options = %UpgradeOptions
@onready var snd_level_up = %SndLevelUp
@onready var item_option = preload("res://Utility/item_option.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	var options = 0
#	var options_max = 3
#	while options < options_max:
#		var option_choice = item_option.instantiate()
#		upgrade_options.add_child(option_choice)
#		options += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
