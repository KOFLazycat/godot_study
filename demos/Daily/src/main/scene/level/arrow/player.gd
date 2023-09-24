extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED:float = 200.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		animated_sprite_2d.play("run")
		if direction.x > 0:
			animated_sprite_2d.flip_h = false
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED/4)
		animated_sprite_2d.play("idle")
	move_and_slide()
