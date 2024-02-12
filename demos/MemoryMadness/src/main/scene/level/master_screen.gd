extends CanvasLayer

@onready var main_screen: Control = $MainScreen
@onready var game_screen: Control = $GameScreen
@onready var sound: AudioStreamPlayer = $Sound


func _ready() -> void:
	on_game_exit_pressed()
	SignalManager.game_exit_pressed.connect(on_game_exit_pressed)
	SignalManager.level_selected.connect(on_level_selected)


func show_game(s: bool) -> void:
	game_screen.visible = s
	main_screen.visible = !s


func on_game_exit_pressed() -> void:
	show_game(false)
	GameManager.clear_nodes_of_group(GameManager.GROUP_TILE)
	SoundManager.play_sound(sound, SoundManager.SOUND_MAIN_MENU, false)


func on_level_selected(level_num: int) -> void:
	show_game(true)
	SoundManager.play_sound(sound, SoundManager.SOUND_IN_GAME, false)
