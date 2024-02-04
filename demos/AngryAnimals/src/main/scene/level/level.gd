extends Node2D

@onready var debug_label: Label = $DebugLabel
@onready var animal_start: Marker2D = $AnimalStart


var animal_scene: PackedScene = preload("res://src/main/scene/role/animal/animal.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	SignalManager.update_debug_label.connect(on_update_debug_label)
	SignalManager.animal_die.connect(on_animal_die)
	on_animal_die()


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE):
		GameManager.load_main_scene()


func setup() -> void:
	var tc = get_tree().get_nodes_in_group(GameManager.GROUP_CUP)
	ScoreManger.set_target_cups(tc.size())


func on_update_debug_label(text: String) -> void:
	debug_label.text = text


func on_animal_die() -> void:
	var animal: Node = animal_scene.instantiate()
	animal.global_position = animal_start.global_position
	add_child(animal)
