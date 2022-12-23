extends CharacterBody2D

@onready var animation_player = $AnimationPlayer


func take_damage(_damage: int):
	animation_player.stop(true)
	animation_player.play("hit")
