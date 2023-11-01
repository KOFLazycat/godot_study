extends Control

signal next()

@onready var time: Label = $VBoxContainer2/HBoxContainer/VBoxContainer3/Time
@onready var early_bumps: Label = $VBoxContainer2/HBoxContainer/VBoxContainer3/EarlyBumps
@onready var late_bumps: Label = $VBoxContainer2/HBoxContainer/VBoxContainer3/LateBumps
@onready var perfect_bumps: Label = $VBoxContainer2/HBoxContainer/VBoxContainer3/PerfectBumps
@onready var bounces: Label = $VBoxContainer2/HBoxContainer/VBoxContainer3/Bounces
@onready var score: Label = $VBoxContainer2/HBoxContainer/VBoxContainer3/Score
@onready var final_score = $VBoxContainer2/HBoxContainer2/FinalScore

var bump_earlylate_multiplicator: int = 500
var bump_perfect_multiplicator: int = 2000
var bounce_multiplicator: int = 10

func _ready() -> void:
	$VBoxContainer/NextBtn.grab_focus()
	update_stats()

func update_stats() -> void:
	var ms = Globals.stats["time"] * 1000
	var seconds: int = int(ms / 1000 )% 60
	var minutes: int = int(ms / 1000 / 60)
	time.text = str(minutes) + ":" + str(seconds)
	early_bumps.text = str(Globals.stats["bumps_early"])
	late_bumps.text = str(Globals.stats["bumps_late"])
	perfect_bumps.text = str(Globals.stats["bumps_perfect"])
	bounces.text = str(Globals.stats["ball_bounces"])
	score.text = str(Globals.stats["score"])
	final_score.text = str((Globals.stats["bumps_early"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_late"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_perfect"]*bump_perfect_multiplicator)+
		(Globals.stats["ball_bounces"]*bounce_multiplicator)+
		Globals.stats["score"])

func _on_NextBtn_pressed() -> void:
	emit_signal("next")
	queue_free()
