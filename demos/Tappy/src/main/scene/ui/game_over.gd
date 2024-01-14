extends Control

@onready var gameover_label: Label = $GameoverLabel
@onready var press_space_label: Label = $PressSpaceLabel
@onready var timer: Timer = $Timer

var _can_press_space: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_can_press_space = false
	gameover_label.show()
	press_space_label.hide()
	timer.timeout.connect(on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _can_press_space == true:
		if Input.is_action_just_pressed("fly") == true:
			Global.load_main_scene()


func on_timer_timeout() -> void:
	gameover_label.hide()
	press_space_label.show()
	_can_press_space = true
