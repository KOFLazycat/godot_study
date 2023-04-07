extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var speed: int = 1000
var screen_size: Vector2 = Vector2.ZERO
var sprite_2d_size: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	sprite_2d_size = sprite_2d.get_rect().size
	sprite_2d_size.x *= scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		position.x -= speed*delta
	if Input.is_action_pressed("right"):
		position.x += speed*delta
	
	position.x = clamp(position.x, sprite_2d_size.x/2, screen_size.x - sprite_2d_size.x/2)


func add_scale_x() ->void:
	scale.x += 0.1

