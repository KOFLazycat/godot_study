extends HSlider

@export var bus: StringName = "Master"

@onready var bus_index: int = AudioServer.get_bus_index(bus)


func _ready() -> void:
	value = SoundManager.get_volume(bus_index)
	value_changed.connect(on_value_changed)


func on_value_changed(v: float) -> void:
	SoundManager.set_volume(bus_index, v)
	Game.save_config()

