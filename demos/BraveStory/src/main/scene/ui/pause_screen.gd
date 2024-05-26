extends Control

@onready var resume: Button = $VBoxContainer/Actions/HBoxContainer/Resume
@onready var quit: Button = $VBoxContainer/Actions/HBoxContainer/Quit


func _ready() -> void:
	resume.pressed.connect(on_resume_pressed)
	quit.pressed.connect(on_quit_pressed)
	visibility_changed.connect(on_visibility_changed)
	SoundManager.setup_ui_sounds(self)
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		hide()
		get_window().set_input_as_handled()


func show_pause() -> void:
	show()
	resume.grab_focus()


func on_resume_pressed() -> void:
	hide()


func on_quit_pressed() -> void:
	Game.back_to_title()


func on_visibility_changed() -> void:
	get_tree().paused = visible





