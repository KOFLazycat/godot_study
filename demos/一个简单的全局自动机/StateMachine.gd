extends Node2D

@onready var state = $state
@onready var root = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func enter_state(_state):
	exit_state()
	state = get_node(_state)
	state.enter_state(self)

func exit_state():
	state.exit_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state.process(delta)
	pass

func _physics_process(delta):
	state.physics_process(delta)
	pass
