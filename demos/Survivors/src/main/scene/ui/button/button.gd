extends Button

@onready var snd_hover: AudioStreamPlayer = $SndHover
@onready var snd_click: AudioStreamPlayer = $SndClick


signal click_end()

func _on_mouse_entered() -> void:
	snd_hover.play()


func _on_pressed() -> void:
	snd_click.play()


func _on_snd_click_finished() -> void:
	emit_signal("click_end")
