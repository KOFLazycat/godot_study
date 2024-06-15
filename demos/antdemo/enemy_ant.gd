class_name EnemyAnt extends CharacterBody2D

@export var player: PlayerAnt
@export var speed: float = 40.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	navigation_agent_2d.navigation_finished.connect(_on_navigation_agent_2d_navigation_finished)
	navigation_agent_2d.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)


func _physics_process(delta: float) -> void:
	var direction: Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	rotation += atan2(direction.x, -direction.y) * delta
	navigation_agent_2d.velocity = Vector2(sin(rotation), -cos(rotation)) * speed


func _on_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.global_position


func _on_navigation_agent_2d_navigation_finished() -> void:
	animated_sprite_2d.stop()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	animated_sprite_2d.play("default")
