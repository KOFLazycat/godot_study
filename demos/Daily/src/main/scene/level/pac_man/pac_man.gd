extends CharacterBody2D

@onready var player: AnimatedSprite2D = $Player

var speed: int = 200
var dir: Vector2 = Vector2.ZERO

signal game_over


func _ready() -> void:
	player.play("default")


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		dir = Vector2.LEFT
		player.rotation_degrees = 180
	if Input.is_action_just_pressed("right"):
		dir = Vector2.RIGHT
		player.rotation_degrees = 0
	if Input.is_action_just_pressed("down"):
		dir = Vector2.DOWN
		player.rotation_degrees = 90
	if Input.is_action_just_pressed("up"):
		dir = Vector2.UP
		player.rotation_degrees = -90
	if Input.is_anything_pressed() == false:
		dir = Vector2.ZERO
	
	velocity = dir * speed
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("monster"):
		emit_signal("game_over")
	if area.is_in_group("gold"):
		Global.glob_score += 1
