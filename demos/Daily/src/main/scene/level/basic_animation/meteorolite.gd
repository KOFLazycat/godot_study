extends Node2D

@onready var sprite_2d = $Area2D/Sprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var velocity = Vector2.ZERO
var target_dir = Vector2.ZERO
var speed = 500
var angle = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += angle
	position += velocity * delta


func _on_area_2d_area_entered(area):
	if area.is_in_group("ground") or area.is_in_group("player"):
		velocity = Vector2.ZERO
		angle = 0
		sprite_2d.hide()
		animated_sprite_2d.show()
		animated_sprite_2d.play("explosion")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
	
	
func set_velocity(player_position, meteorolite_position):
	position = meteorolite_position
	target_dir = (player_position - meteorolite_position).normalized()
	velocity = target_dir * speed
