extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton

var options_scene = preload("res://src/main/scene/ui/options_menu.tscn") as PackedScene


func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func on_play_pressed() -> void:
	ScreenTransition.transition()
	#await ScreenTransition.transition_halfway
	await ScreenTransition.animation_player.animation_finished
	get_tree().change_scene_to_file("res://src/main/scene/level/main/main.tscn")


func on_options_pressed() -> void:
	ScreenTransition.transition()
	#await ScreenTransition.transition_halfway
	await ScreenTransition.animation_player.animation_finished
	var options_instance = options_scene.instantiate()
	add_child(options_instance)


func on_quit_pressed() -> void:
	get_tree().quit()
