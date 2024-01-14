extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const GRAVITY: float = 1900.0
const POWER: float = -300.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	fly()
	
	move_and_slide()
	
	if is_on_floor():
		die()


func fly() -> void:
	if Input.is_action_pressed("fly"):
		velocity.y = POWER
		animation_player.play("fly")


func die() -> void:
	animated_sprite_2d.stop()
	set_physics_process(false)
