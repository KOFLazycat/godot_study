extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vanish_sound: AudioStreamPlayer2D = $VanishSound


func die() -> void:
	vanish_sound.play()
	animation_player.play("vanish")
	await vanish_sound.finished and animation_player.animation_finished
	SignalManager.cup_destroyed.emit()
	queue_free()
