extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var upgrades_button: Button = %UpgradesButton

var options_scene = preload("res://src/main/scene/ui/options_menu.tscn") as PackedScene
var meta_scene = preload("res://src/main/scene/ui/meta_menu.tscn") as PackedScene


func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	upgrades_button.pressed.connect(on_upgrades_pressed)


func on_play_pressed() -> void:
	ScreenTransition.transition_to_scene("res://src/main/scene/level/main/main.tscn")


func on_upgrades_pressed() -> void:
	ScreenTransition.transition()
	#await ScreenTransition.transition_halfway
	await ScreenTransition.animation_player.animation_finished
	var meta_instance = meta_scene.instantiate()
	add_child(meta_instance)


func on_options_pressed() -> void:
	ScreenTransition.transition()
	#await ScreenTransition.transition_halfway
	await ScreenTransition.animation_player.animation_finished
	var options_instance = options_scene.instantiate()
	add_child(options_instance)


func on_quit_pressed() -> void:
	get_tree().quit()
