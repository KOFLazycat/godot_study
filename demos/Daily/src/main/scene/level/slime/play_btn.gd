extends Node2D

@onready var texture_button = $TextureButton
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

signal game_start


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.play()
	texture_button.self_modulate.a8 = 200



func _on_texture_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.play()
	texture_button.self_modulate.a8 = 255


func _on_texture_button_button_down():
	var tween = create_tween()
#	tween.tween_property(texture_button,"scale",Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(self,"position",Vector2(1500, self.global_position.y), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.play()
	audio_stream_player_2d.play()
	emit_signal("game_start")
	await tween.finished and audio_stream_player_2d.finished
	queue_free()
