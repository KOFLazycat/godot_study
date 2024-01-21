extends Node2D

@onready var debug_label: Label = $DebugLabel
@onready var animal_start: Marker2D = $AnimalStart


var animal_scene: PackedScene = preload("res://src/main/scene/role/animal/animal.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.update_debug_label.connect(on_update_debug_label)
	SignalManager.animal_die.connect(on_animal_die)
	on_animal_die()


func on_update_debug_label(text: String) -> void:
	debug_label.text = text


func on_animal_die() -> void:
	var animal: Node = animal_scene.instantiate()
	animal.global_position = animal_start.global_position
	add_child(animal)
