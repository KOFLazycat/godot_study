extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED: float = 30.0
var dir: Vector2 = Vector2.ZERO
var ani_enemy: Array = ["enemy1", "enemy2", "enemy3", "enemy4"]


func _ready() -> void:
	animated_sprite_2d.play(ani_enemy[randi_range(0, 3)])


func _physics_process(delta: float) -> void:
	if dir != Vector2.ZERO:
		velocity = dir * SPEED
		if dir.x > 0:
			animated_sprite_2d.flip_h = false
		if dir.x < 0:
			animated_sprite_2d.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 10.0)

	move_and_slide()


func _on_area_2d_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		dir = (body.global_position - self.global_position).normalized()


func _on_area_2d_detection_body_exited(body: Node2D) -> void:
	dir = Vector2.ZERO
