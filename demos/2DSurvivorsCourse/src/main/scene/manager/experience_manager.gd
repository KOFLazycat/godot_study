extends Node

var current_experience: float = 0


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
	current_experience += number
	print(current_experience)


func on_experience_vial_collected(number: float) -> void:
	increment_experience(number)
