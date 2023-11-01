extends Node2D

var bump_to_str = {
	Globals.BUMP.TOO_FAR: "TOO FAR",
	Globals.BUMP.EARLY: "EARLY",
	Globals.BUMP.LATE: "LATE",
	Globals.BUMP.PERFECT: "PERFECT"
}

var type = Globals.BUMP.EARLY

func _ready() -> void:
	$Label.text = bump_to_str[type]
	appear()
	
func appear() -> void:
	visible = true
	$Timer.start()
	
func disappear() -> void:
	visible = false

func _process(delta) -> void:
	pass

func _on_timer_timeout():
	disappear()
