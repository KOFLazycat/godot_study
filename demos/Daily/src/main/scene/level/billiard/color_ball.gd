extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D


@export var texture: Texture2D


func _ready() -> void:
	sprite_2d.texture = texture


func _physics_process(delta: float) -> void:
	position.x = clampf(position.x, 70.0, 890.0)
	position.y = clampf(position.y, 157.0, 563.0)
