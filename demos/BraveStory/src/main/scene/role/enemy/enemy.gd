class_name Enemy
extends CharacterBody2D

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine

enum Direction {
	LEFT = -1,
	RIGHT = +1
}

@export var direction := Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = -direction
## 最大速度
@export var max_speed: float = 180
## 加速度
@export var acceleration: float = 2000

var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float

func move(delta: float, speed: float) -> void:
	velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
	velocity.y += default_gravity * delta
	move_and_slide()
