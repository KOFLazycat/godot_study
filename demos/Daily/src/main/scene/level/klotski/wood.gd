extends CharacterBody2D

@onready var texture_button = $TextureButton

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var speed = 90000
var id = 0
var move = false
var old_pos = Vector2.ZERO
var new_pos = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 0

func _ready():
	velocity = Vector2.ZERO

func _physics_process(delta):
	if Global.glob_id == id:
		new_pos = get_global_mouse_position()
		if rotation_degrees == 0:
			if new_pos.x - old_pos.x > 0:
				velocity = Vector2.RIGHT * speed * delta
			if new_pos.x - old_pos.x < 0:
				velocity = Vector2.LEFT * speed * delta
		if rotation_degrees == -90:
			if new_pos.y - old_pos.y > 0:
				velocity = Vector2.DOWN * speed * delta
			if new_pos.y - old_pos.y < 0:
				velocity = Vector2.UP * speed * delta
		move_and_slide()
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	else:
		velocity = Vector2.ZERO


func init_wood(_id, _dir, _pos):
	position = _pos
	id = _id
	texture_button.modulate.a8 = 200
	rotation_degrees = _dir


func _on_texture_button_button_down():
	if Global.glob_id == 0:
		Global.glob_id = id
		old_pos = get_global_mouse_position()


func _on_texture_button_button_up():
	Global.glob_id = 0


func _on_texture_button_mouse_entered():
	texture_button.modulate.a8 = 255


func _on_texture_button_mouse_exited():
	texture_button.modulate.a8 = 200
