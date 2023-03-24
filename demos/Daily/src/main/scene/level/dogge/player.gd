extends Node2D

@onready var player_dogger = $PlayerDogger
@onready var gpu_particles_2d = $GPUParticles2D


var speed = 500
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var screen_size = Vector2.ZERO

signal game_over


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector2.ZERO
	if Input.is_action_pressed("left"):
		direction = Vector2.LEFT
		player_dogger.flip_h = true
		player_dogger.flip_v = false
		player_dogger.play("walk")
	if Input.is_action_pressed("right"):
		direction = Vector2.RIGHT
		player_dogger.flip_h = false
		player_dogger.flip_v = false
		player_dogger.play("walk")
	if Input.is_action_pressed("up"):
		direction = Vector2.UP
		player_dogger.flip_h = false
		player_dogger.flip_v = false
		player_dogger.play("up")
	if Input.is_action_pressed("down"):
		direction = Vector2.DOWN
		player_dogger.flip_h = false
		player_dogger.flip_v = true
		player_dogger.play("up")
	if direction == Vector2.ZERO:
		player_dogger.stop()
	
	velocity = direction * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_area_2d_area_entered(area):
	if area.is_in_group("monster"):
		emit_signal("game_over")
