extends TextureButton

@export var level_number: int = 1

@onready var level_button: TextureButton = $"."
@onready var level_label: Label = $MC/VB/LevelLabel
@onready var score_label: Label = $MC/VB/ScoreLabel

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)
var _level_scene: PackedScene

func _ready() -> void:
	level_label.text = str(level_number)
	score_label.text = str(ScoreManger.get_best_for_level(level_number))
	level_button.pressed.connect(on_level_button_pressed)
	level_button.mouse_entered.connect(on_level_button_mouse_entered)
	level_button.mouse_exited.connect(on_level_button_mouse_mouse_exited)
	_level_scene = load("res://src/main/scene/level/level_%s.tscn" % level_number)


func on_level_button_pressed() -> void:
	ScoreManger.level_selected(level_number)
	get_tree().change_scene_to_packed(_level_scene)


func on_level_button_mouse_entered() -> void:
	scale = HOVER_SCALE


func on_level_button_mouse_mouse_exited() -> void:
	scale = DEFAULT_SCALE
