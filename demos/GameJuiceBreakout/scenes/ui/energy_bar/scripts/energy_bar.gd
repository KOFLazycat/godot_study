extends Control

@export var max_particles: int = 300

@onready var progress: ProgressBar = $EnergyBar
@onready var gpu_particles_2d: GPUParticles2D = $EnergyBar/GPUParticles2D
@onready var shaker: Shaker = $Shaker


func _ready() -> void:
	progress.value = 0.0
	gpu_particles_2d.amount = 1
	progress.rotation = 0.0


func set_energy(new_value: int) -> void:
	if new_value > 90.0 and new_value > progress.value:
		shaker.start()
	elif new_value < 90.0:
		shaker.stop()
	progress.value = new_value
	gpu_particles_2d.amount = clamp(max_particles * (new_value/100.0), 1, max_particles)
	
