extends Control


const LINES: Array[String] = [
	"在无尽的征途中，他们终于找到了失落的文明，拯救了濒临毁灭的世界。",
	"新的黎明在地平线上升起，带来了和平与繁荣。",
	"他们的勇气和智慧铸就了永恒的传奇，成为历史长河中闪耀的星辰。",
	"而他们的故事，将永远被人们传颂，直至万古长存。"
]

var current_line: int = 0
var tween: Tween

@onready var label: Label = $Label


func _ready() -> void:
	show_line(current_line)
	SoundManager.play_bgm(preload("res://src/main/assets/sounds/29 15 game over LOOP.mp3"))


func _input(event: InputEvent) -> void:
	if tween.is_running():
		return
	
	if (event is InputEventKey or 
		event is InputEventMouse or
		event is InputEventJoypadButton
	):
		if event.is_pressed() and not event.is_echo():
			current_line = current_line + 1
			if current_line < LINES.size():
				show_line(current_line)
			else:
				Game.back_to_title()


func show_line(line: int) -> void:
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	if line > 0:
		tween.tween_property(label, "modulate:a", 0, 1)
	else:
		label.modulate.a = 0
	
	tween.tween_callback(label.set_text.bind(LINES[line]))
	tween.tween_property(label, "modulate:a", 1, 1)











