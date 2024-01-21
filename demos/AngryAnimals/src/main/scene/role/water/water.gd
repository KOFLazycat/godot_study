extends Area2D

@onready var splash_sound: AudioStreamPlayer2D = $SplashSound
@onready var water: Area2D = $"."


func _ready() -> void:
	water.body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D) -> void:
	if body.is_in_group(GameManager.GROUP_ANIMAL):
		splash_sound.play()
