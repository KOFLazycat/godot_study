extends CharacterBody2D

@export var selected:bool = false
@onready var box = $Box
@onready var target = position
@onready var animation_player = $AnimationPlayer

var follow_cursor:bool = false
var speed:int = 50


func _ready():
	set_selected(selected)
	
	
func set_selected(value:bool):
	box.visible = value
	selected = value


func _input(event):
	if event.is_action_pressed("RightClick"):
		follow_cursor = true
	if event.is_action_released("RightClick"):
		follow_cursor = false


func _physics_process(delta):
	if follow_cursor && selected:
		target = get_global_mouse_position()
		animation_player.play("walkdown")
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()
	else:
		animation_player.stop()	
	





