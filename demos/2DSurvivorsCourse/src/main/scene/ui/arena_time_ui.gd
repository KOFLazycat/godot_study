extends CanvasLayer

@export var arena_time_manager: Node
@onready var label: Label = $MarginContainer/Label


func _process(_delta: float) -> void:
	if is_instance_valid(arena_time_manager):
		var time_elapsed: float = arena_time_manager.get_time_elapsed()
		label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var remaining_seconds = floor(seconds - minutes * 60)
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds)
