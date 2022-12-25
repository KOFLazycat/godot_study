extends CharacterBody2D


@export var health_max = 100

var health = health_max
var pushback_force = Vector2.ZERO

@onready var animation_player = $AnimationPlayer
@onready var hit_particles = $HitParticles
@onready var damage_spawning_point = $DamageSpawningPoint


func take_damage(amount: int):
	health = max(0, health - amount)
	animation_player.play("hit")
	var damage_label = preload("res://src/main/scene/role/label/damage_label.tscn").instantiate()
	damage_label.global_position = damage_spawning_point.global_position
	damage_label.set_damage(amount)
	EventBus.emit_signal("enemy_hit")
	add_child(damage_label)


func knock_back(source_position: Vector2):
	hit_particles.rotation = get_angle_to(source_position) + PI
	pushback_force = -global_position.direction_to(source_position) * 300


func _physics_process(delta: float):
	pushback_force = lerp(pushback_force, Vector2.ZERO, delta * 10)
	move_and_slide()
