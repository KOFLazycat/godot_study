extends Control

@onready var progress: ProgressBar = $EnergyBar

func _ready() -> void:
	progress.value = 0.0

func set_energy(new_value: int) -> void:
	progress.value = new_value
