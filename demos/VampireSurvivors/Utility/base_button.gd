extends Button

@onready var snd_hover = $SndHover
@onready var snd_click = $SndClick

signal click_end()


func _on_mouse_entered():
	snd_hover.play()


func _on_pressed():
	snd_click.play()


func _on_snd_click_finished():
	emit_signal("click_end")
