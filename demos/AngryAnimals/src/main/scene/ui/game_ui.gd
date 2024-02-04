extends CanvasLayer

@onready var level_label: Label = $MC/VB/LevelLabel
@onready var attempts_label: Label = $MC/VB/AttemptsLabel
@onready var vb_2: VBoxContainer = $MC/VB2
@onready var sound: AudioStreamPlayer = $Sound


func _ready() -> void:
	level_label.text = "Level %s" % ScoreManger.get_level_selected()
	on_attempt_made()
	SignalManager.attempt_made.connect(on_attempt_made)
	SignalManager.game_over.connect(on_game_over)


func _process(_delta: float) -> void:
	if vb_2.visible == true and Input.is_key_pressed(KEY_SPACE) == true:
		GameManager.load_main_scene()


func on_attempt_made() -> void:
	attempts_label.text = "Attempts %s" % ScoreManger.get_attempts()


func on_game_over() -> void:
	vb_2.show()
	sound.play()
