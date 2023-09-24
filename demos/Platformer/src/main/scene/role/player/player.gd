class_name Player
extends CharacterBody2D

@onready var transform_adjustment: Node2D = $TransformAdjustment
@onready var animation_player: AnimationPlayer = $AnimationPlayer


## 设置组
@export_group("setting")
## 移动速度
@export var speed: float = 300.0
## 跳跃速度
@export var jump_velocity: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	_set_facing_direction(direction)
	
	move_and_slide()
	
	_update_animation()


func _set_facing_direction(direction_x: float) -> void:
	var scale_x = sign(direction_x)
	
	if scale_x != 0:
		transform_adjustment.scale.x = scale_x


func _update_animation() -> void:
	if is_on_floor():
		if velocity.x != 0:
			animation_player.play("run")
		else:
			animation_player.play("idle")
	else:
		if velocity.y > 0:
			animation_player.play("fall")
		else:
			animation_player.play("jump")
