extends Control

@onready var exit_button: TextureButton = $HB/MC2/VB/ExitButton
@onready var sound: AudioStreamPlayer = $Sound


func _ready() -> void:
	exit_button.pressed.connect(on_exit_button_pressed)


func on_exit_button_pressed() -> void:
	SoundManager.play_button_click(sound, true)
	SignalManager.game_exit_pressed.emit()
