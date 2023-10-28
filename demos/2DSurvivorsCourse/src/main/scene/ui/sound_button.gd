extends Button

@onready var random_stream_player_component: AudioStreamPlayer = $RandomStreamPlayerComponent


func _ready() -> void:
	pressed.connect(on_pressed)


func on_pressed() -> void:
	random_stream_player_component.play_random()
