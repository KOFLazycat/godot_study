class_name FireBall
extends TargetActionView

@onready var fire_ball_particles: GPUParticles2D = $SRT/FireBallParticles
@onready var tail_particles: GPUParticles2D = $SRT/TailParticles
@onready var tail_dot_particles: GPUParticles2D = $SRT/TailDotParticles
@onready var explode_particles: GPUParticles2D = $ExplodeParticles
@onready var explode_dot_particles: GPUParticles2D = $ExplodeDotParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super()
	spawn_animation.connect(on_spawn_animation)
	move_animation.connect(on_move_animation)
	hit_animation.connect(on_hit_animation)


func on_spawn_animation() -> void:
	pass


func on_move_animation() -> void:
	animation_player.play("move")


func on_hit_animation() -> void:
	fire_ball_particles.emitting = false
	tail_particles.emitting = false
	tail_dot_particles.emitting = false
	explode_particles.restart()
	explode_dot_particles.restart()
