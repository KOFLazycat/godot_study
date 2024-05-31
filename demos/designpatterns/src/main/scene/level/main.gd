extends Node2D


func _on_button_pressed() -> void:
	AudioSystem.play_bgm(0)


func _on_button_2_pressed() -> void:
	AudioSystem.play_bgm(0)


func _on_button_3_pressed() -> void:
	AudioSystem.play_sfx(randi_range(0, AudioSystem.sfxs.size() - 1))
