extends Control

signal next()

@onready var time: Label = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer/Time
@onready var early_bumps: Label = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer/EarlyBumps
@onready var late_bumps: Label = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer/LateBumps
@onready var perfect_bumps: Label = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer/PerfectBumps
@onready var bounces: Label = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer/Bounces
@onready var score: Label = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer/Score

@onready var final_score = $StatsVBoxContainer/HBoxContainer2/FinalScore

var bump_earlylate_multiplicator: int = 500
var bump_perfect_multiplicator: int = 2000
var bounce_multiplicator: int = 10

func _ready() -> void:
	#$VBoxContainer/NextBtn.grab_focus()
	#Globals.stats["ball_bounces"] = 1000
	#Globals.stats["score"] = 1000
	update_stats()
	hide_stats()
	#animate_stats()

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


func hide_stats() -> void:
	for child in $StatsVBoxContainer/HBoxContainer/StatsNameVBoxContainer.get_children():
		child.self_modulate.a = 0.0
	for child in $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer.get_children():
		child.self_modulate.a = 0.0
	
	$StatsVBoxContainer/HBoxContainer2/Label.self_modulate.a = 0.0
	final_score.self_modulate.a = 0.0
	$VBoxContainer.modulate.a = 0.0


func animate_stats() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	# move labels from left to right
	for child in $StatsVBoxContainer/HBoxContainer/StatsNameVBoxContainer.get_children():
		tween.tween_property(child, "position:x", 0.0, 0.25).from(-get_viewport_rect().size.x)
		tween.parallel().tween_property(child, "self_modulate:a", 1.0, 0.25).from(0.0)
	# Animate stats values
	for i in range($StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer.get_child_count()):
		var child = $StatsVBoxContainer/HBoxContainer/StatsValueVBoxContainer.get_child(i)
		var key = Globals.stats.keys()[i]
		tween.tween_method(set_label_number.bind(child), 0, Globals.stats[key], 0.5)
		tween.parallel().tween_property(child, "self_modulate:a", 1.0, 0.05).from(0.0)
		#tween.parallel().tween_callback(screen_shake.bind(0.4, 20, 10))
		tween.parallel().tween_callback($Shaker.start.bind(0.25))
		tween.tween_interval(0.25)
	tween.tween_interval(0.25)
	
	# Move Final score label left to right
	tween.tween_property($StatsVBoxContainer/HBoxContainer2/Label, "position:x", 0.0, 0.3).from(-get_viewport_rect().size.x)
	tween.parallel().tween_property($StatsVBoxContainer/HBoxContainer2/Label, "self_modulate:a", 1.0, 0.25).from(0.0)
	
	# final score count up
	tween.tween_method(set_label_number.bind(final_score), 0, str_to_var(final_score.text), 0.5)
	tween.parallel().tween_property(final_score, "self_modulate:a", 1.0, 0.05).from(0.0)
	#tween.parallel().tween_callback(screen_shake.bind(1.0, 30, 25))
	tween.parallel().tween_callback($Shaker.start.bind(1.0))
	tween.tween_interval(1.0)
	
	tween.tween_property($VBoxContainer, "position:y", 904, 0.3).from(get_viewport_rect().size.y)
	tween.parallel().tween_property($VBoxContainer, "modulate:a", 1.0, 0.1).from(0.0)
	tween.tween_callback($VBoxContainer/NextBtn.grab_focus)


func set_label_number(number: int, label: Label) -> void:
	label.set_text(str(number))


func screen_shake(duration: float, frequency: float, amplitude: float) -> void:
	Globals.camera.shake(duration, frequency, amplitude)


func _on_NextBtn_pressed() -> void:
	emit_signal("next")
	queue_free()
