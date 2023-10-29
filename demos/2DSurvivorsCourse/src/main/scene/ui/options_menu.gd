extends CanvasLayer

signal back_pressed

@onready var sfx_h_slider: HSlider = %SfxHSlider
@onready var music_h_slider: HSlider = %MusicHSlider
@onready var window_button: Button = %WindowButton
@onready var back_button: Button = %BackButton


func _ready() -> void:
	window_button.pressed.connect(on_window_pressed)
	back_button.pressed.connect(on_back_pressed)
	sfx_h_slider.value_changed.connect(on_audio_slider_value_changed.bind("SFX"))
	music_h_slider.value_changed.connect(on_audio_slider_value_changed.bind("Music"))
	update_display()


func update_display() -> void:
	window_button.text = "Window"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	
	sfx_h_slider.value = get_bus_volume_percent("SFX")
	music_h_slider.value = get_bus_volume_percent("Music")


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_window_pressed() -> void:
	var mode: int = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	update_display()


func on_back_pressed() -> void:
	queue_free()


func on_audio_slider_value_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, value)
