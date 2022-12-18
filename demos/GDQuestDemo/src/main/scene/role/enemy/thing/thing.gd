extends CharacterBody2D


@onready var animation_player = $AnimationPlayer
@export var health_max = 100

var health := health_max

func take_damage(amount: int):
	health = max(0, health - amount)
	print(health)
	animation_player.play("thing_hit")
