extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : int = 10
@export var limit : float = 0.5

var startPosition : Vector2
var endPosition : Vector2

func _ready() -> void:
	startPosition = position
	endPosition = startPosition + Vector2(0, 3*16)
	

func _physics_process(delta: float) -> void:
	updateVelocity()
	updateAnimation()
	move_and_slide()
	

func updateVelocity() -> void:
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed


func changeDirection() -> void:
	var tmpEnd:Vector2 = endPosition
	endPosition = startPosition
	startPosition = tmpEnd
	
	
func updateAnimation() -> void:
	var animation_name : String = "walk_up"
	if velocity.y > 0:
		animation_name = "walk_down"
	animated_sprite_2d.play(animation_name)
