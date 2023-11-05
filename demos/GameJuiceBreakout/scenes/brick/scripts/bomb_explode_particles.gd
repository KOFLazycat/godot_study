extends GPUParticles2D

@onready var timer: Timer = $Timer

var lifetime_offset = 0.5


func _ready() -> void:
	emitting = true
	timer.start(lifetime + lifetime_offset)
	timer.timeout.connect(on_timeout)


func on_timeout() -> void:
	queue_free()
