extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


var ani_coin: Array = ["yellow", "blue", "green", "red"]
var dir: Vector2 = Vector2.ZERO
var SPEED: float = 10.0


func _process(delta: float) -> void:
	if dir != Vector2.ZERO:
		position += dir * SPEED


func play_coin(pos) -> void:
	animated_sprite_2d.play(ani_coin[randi_range(0, 3)])
	position = pos


func _on_area_2d_body_entered(body: Node2D) -> void:
	collision_shape_2d.set_deferred("disabled", true)
	dir = (body.global_position - self.global_position).normalized()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	queue_free()


