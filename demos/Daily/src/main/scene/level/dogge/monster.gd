extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


var speed = randi_range(100, 300)
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	var ani_names = animated_sprite_2d.sprite_frames.get_animation_names()
	animated_sprite_2d.animation = ani_names[randi()%ani_names.size()]
	animated_sprite_2d.play(animated_sprite_2d.animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta
	

func spawn(dir, pos):
	position = pos
	velocity = dir * speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
