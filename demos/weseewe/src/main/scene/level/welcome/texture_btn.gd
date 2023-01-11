extends TextureButton

signal _button_down
signal _button_up
signal _pressed


func _on_button_down():
	position.x -= 5
	position.y += 5
	modulate = Color(0.8, 0.8, 0.8)
	emit_signal("_button_down")


func _on_button_up():
	position.x += 5
	position.y -= 5
	modulate = Color(1, 1, 1)
	emit_signal("_button_up")


func _on_pressed():
	emit_signal("_pressed")


