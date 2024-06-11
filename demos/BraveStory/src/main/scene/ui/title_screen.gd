extends Control

@onready var new_game: Button = $VB/NewGame
@onready var load_game: Button = $VB/LoadGame
@onready var exit_game: Button = $VB/ExitGame
@onready var vb: VBoxContainer = $VB


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	load_game.disabled = not Game.has_save()
	new_game.grab_focus()
	
	new_game.pressed.connect(on_new_game_pressed)
	load_game.pressed.connect(on_load_game_pressed)
	exit_game.pressed.connect(on_exit_game_pressed)
	
	SoundManager.setup_ui_sounds(self)
	SoundManager.play_bgm(preload("res://src/main/assets/sounds/02 1 titles LOOP.mp3"))


func on_new_game_pressed() -> void:
	Game.new_game()


func on_load_game_pressed() -> void:
	Game.load_game()


func on_exit_game_pressed() -> void:
	get_tree().quit()
