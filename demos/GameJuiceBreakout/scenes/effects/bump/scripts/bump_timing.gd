extends Node2D

@export var color_too_far: Color
@export var color_early: Color
@export var color_late: Color
@export var color_perfect: Color

@onready var bump_colors = {
	Globals.BUMP.TOO_FAR: color_too_far,
	Globals.BUMP.EARLY: color_early,
	Globals.BUMP.LATE: color_late,
	Globals.BUMP.PERFECT: color_perfect
}
@onready var label: Label = $Label
@onready var gpu_particles_2d: GPUParticles2D = $Label/GPUParticles2D


var bump_to_str = {
	Globals.BUMP.TOO_FAR: "TOO FAR",
	Globals.BUMP.EARLY: "EARLY",
	Globals.BUMP.LATE: "LATE",
	Globals.BUMP.PERFECT: "PERFECT"
}

var type = Globals.BUMP.EARLY
var tween: Tween

func _ready() -> void:
	label.text = bump_to_str[type]
	label.self_modulate = bump_colors[type]
	label.scale = Vector2.ZERO
	appear()
	
func appear() -> void:
	visible = true
	if type == Globals.BUMP.PERFECT:
		gpu_particles_2d.emitting = true
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(label, "rotation_degrees", randf_range(-25.0, 25.0), 1.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position", Vector2(randf_range(-100.0, 100.0), randf_range(-100.0, -25.0)), 1.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2.ONE, 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(label, "scale", Vector2.ZERO, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(disappear)


func disappear() -> void:
	visible = false
	queue_free()
