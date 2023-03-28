extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var label_timer = $AnimatedSprite2D/LabelTimer
@onready var timer = $Timer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@onready var sound_explosion = preload("res://src/main/assets/texture/bomb_hero/b.wav")
@onready var sound_countdown = preload("res://src/main/assets/texture/bomb_hero/c.wav")

var countdown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	countdown = 4
	timer.start(1)
	animated_sprite_2d.scale = Vector2(2, 2)
	animated_sprite_2d.play("countdown")
	collision_shape_2d.disabled = true
	label_timer.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn(_pos):
	position = _pos


func _on_timer_timeout():
	countdown -= 1
	label_timer.text = str(countdown)
	label_timer.show()
	audio_stream_player_2d.stream = sound_countdown
	audio_stream_player_2d.play()
	if countdown == 0:
		label_timer.hide()
		collision_shape_2d.disabled = false
		collision_shape_2d.scale = Vector2(8, 8)
		animated_sprite_2d.scale = Vector2(3, 3)
		animated_sprite_2d.play("explosion")
		audio_stream_player_2d.stream = sound_explosion
		audio_stream_player_2d.play()
		await get_tree().create_timer(0.3).timeout
		queue_free()
