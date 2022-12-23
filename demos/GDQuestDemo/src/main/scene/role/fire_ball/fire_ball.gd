extends Node2D

@onready var explosion_particles = $ExplosionParticles
@onready var common_hit_box = $CommonHitBox
@onready var timer = $Timer
@onready var sprite_2d = $Sprite2D
@onready var impact_detector = $ImpactDetector

@export var speed = 1000.0
@export var lifetime = 2.0
var direction := Vector2.ZERO


func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	timer.connect("timeout", Callable(self, "_on_impact"))
	timer.start(lifetime)
	impact_detector.connect("body_entered", Callable(self, "_on_impact"))
	
	
func _physics_process(delta):
	position += direction * speed * delta


func _on_impact(_body):
	common_hit_box.set_disabled(false)
	speed = 0.0
	explosion_particles.emitting = true
	sprite_2d.visible = false
	get_tree().create_timer(explosion_particles.lifetime).connect("timeout", Callable(self, "_disable_hitbox"))


func _disable_hitbox():
	common_hit_box.set_disabled(true)
	queue_free()
