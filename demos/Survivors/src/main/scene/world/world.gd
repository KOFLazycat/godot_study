extends Node2D

@onready var snd_music: AudioStreamPlayer = $SndMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cat_player_death() -> void:
	snd_music.stop()
