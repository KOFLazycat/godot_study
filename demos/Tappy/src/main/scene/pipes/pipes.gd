extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var laser: Area2D = $Laser
@onready var upper: Area2D = $Upper
@onready var lower: Area2D = $Lower
@onready var score_sound: AudioStreamPlayer = $ScoreSound


const SCROLL_SPEED: float = 80.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(on_visible_on_screen_notifier_2d_screen_exited)
	laser.body_entered.connect(on_laser_body_entered)
	upper.body_entered.connect(on_pipe_body_entered)
	lower.body_entered.connect(on_pipe_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= SCROLL_SPEED * delta


func on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func on_laser_body_entered(body: Node2D) -> void:
	if body.is_in_group(Global.GROUP_PLANE):
		score_sound.play()
		Global.increment_score()
		laser.set_collision_disabled()


func on_pipe_body_entered(body: Node2D) -> void:
	if body.is_in_group(Global.GROUP_PLANE):
		body.die()
