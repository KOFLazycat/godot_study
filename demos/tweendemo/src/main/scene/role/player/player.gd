class_name Player
extends CharacterBody2D

@export var speed: float = 300.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var knockback: Vector2 = Vector2.ZERO
@onready var blood: Blood = $Sprite2D/Blood

var health: float = 1.0


func _ready() -> void:
	blood.init_health(health)


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var movement: Vector2 = input_direction * speed
	velocity = movement + knockback
	
	move_and_slide()
	
	#if Input.is_action_just_pressed("hit"):
		#hit(Vector2(200, 0))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		hit(Vector2(200, 0))
		health -= 0.4
		blood.set_health(health)


func hit(knock_back_strength: Vector2 = Vector2.ZERO, time: float = 0.25) -> void:
	knockback = knock_back_strength
	var knockback_tween = get_tree().create_tween()
	knockback_tween.parallel().tween_property(self, "knockback", Vector2.ZERO, time)
	sprite_2d.self_modulate = Color.CRIMSON
	knockback_tween.parallel().tween_property(sprite_2d, "self_modulate", Color.WHITE, time)
