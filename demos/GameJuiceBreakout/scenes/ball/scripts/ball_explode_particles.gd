extends GPUParticles2D

@onready var timer: Timer = $Timer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var lifetime_offset = 0.5


func _ready() -> void:
	emitting = true
	gpu_particles_2d.emitting = true
	timer.start(lifetime + lifetime_offset)
	timer.timeout.connect(on_timeout)


func on_timeout() -> void:
	queue_free()
