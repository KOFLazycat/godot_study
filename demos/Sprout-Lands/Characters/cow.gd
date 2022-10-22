extends CharacterBody2D

enum COW_STATE { IDLE, WALK }

@export var move_speed : float = 20
@export var idle_time : float = 5
@export var walk_time : float = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE

func _ready():
	pick_new_state()


func _physics_process(_delta):
	if (current_state == COW_STATE.WALK):
		velocity = move_direction * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	)
	
	if (move_direction.x < 0):
		sprite.flip_h = true
	elif (move_direction.x > 0):
		sprite.flip_h = false


func pick_new_state():
	if (current_state == COW_STATE.IDLE):
		select_new_direction()
		while move_direction == Vector2.ZERO:
			select_new_direction()
		state_machine.travel("Walk")
		current_state = COW_STATE.WALK
		timer.start(walk_time + randi_range(-1, 4))
	else:
		state_machine.travel("Idle")
		current_state = COW_STATE.IDLE
		timer.start(idle_time + randi_range(-4, 4))
		



func _on_timer_timeout():
	pick_new_state()
