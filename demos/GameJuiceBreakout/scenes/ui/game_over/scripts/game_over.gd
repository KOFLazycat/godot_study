extends Control

signal retry()

func _ready() -> void:
	$VBoxContainer/RetryBtn.grab_focus()

func _on_RetryBtn_pressed() -> void:
	emit_signal("retry")
	queue_free()

func _on_QuitBtn_pressed() -> void:
	get_tree().quit()
