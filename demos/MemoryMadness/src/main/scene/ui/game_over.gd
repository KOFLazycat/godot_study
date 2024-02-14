extends Control

@onready var moves_label: Label = $NinePatchRect/MC/VB/HB/MovesLabel
@onready var exit_button: TextureButton = $NinePatchRect/MC/VB/ExitButton


func _ready() -> void:
	exit_button.pressed.connect(on_exit_button_pressed)
	SignalManager.game_over.connect(on_game_over)


func on_exit_button_pressed() -> void:
	hide()
	SignalManager.game_exit_pressed.emit()


func on_game_over(moves: int) -> void:
	moves_label.text = str(moves)
	show()
