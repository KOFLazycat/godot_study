extends TextureButton

@onready var level_button: TextureButton = $"."
@onready var label: Label = $Label
@onready var sound: AudioStreamPlayer = $Sound

var _level_number: int = 0


func _ready() -> void:
	level_button.pressed.connect(on_level_button_pressed)


func set_level_number(level_num: int) -> void:
	_level_number = level_num
	var l_data: Dictionary = GameManager.LEVELS[_level_number]
	label.text = "%sX%s" % [l_data.rows, l_data.cols]


func on_level_button_pressed() -> void:
	SoundManager.play_button_click(sound, true)
	SignalManager.level_selected.emit(_level_number)
