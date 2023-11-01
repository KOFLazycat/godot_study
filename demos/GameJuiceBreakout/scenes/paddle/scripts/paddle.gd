extends CharacterBody2D

signal start()

@export var speed: float = 400.0
@export var bump_force: float = 500.0
@export var accel: float = 20.0
@export var deccel: float = 10.0
@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.1

var dashing: bool = false
var ball_attached = null
var bumping: bool = false : get = get_bumping, set = set_bumping
var game_over: bool = false
var stage_clear: bool = false
var ball = null
var frames_since_bump: int = 0

@onready var dash_timer: Timer = $DashTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var launch_point: Marker2D = $LaunchPoint
@onready var laser: Area2D = $Laser
@onready var thickness: float = $CollisionShape2D.shape.extents.y

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if dashing or game_over or stage_clear: return
	var dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	velocity.x = dir * speed
	
	if Input.is_action_just_pressed("bump"):
		frames_since_bump = 0
		anim.play("bump")
		if ball_attached:
			launch_ball()
		else:
			ball.bump_boost(self)
	
	if Input.is_action_just_pressed("dash") and not dashing:
		dashing = true
		dash_timer.start(dash_duration)
		velocity.x = sign(velocity.x) * dash_speed
		
	if Input.is_action_just_pressed("special"):
		if get_parent().energy == 100.0:
			laser.shoot()
			get_parent().remove_energy(100)
		
	if Input.is_action_pressed("attract"):
		if not ball: return
		if get_parent().energy > delta*5:
			get_parent().remove_energy(delta*5)
			ball.attract(position)
	
func _physics_process(delta: float) -> void:
	if game_over or stage_clear: return
	
	frames_since_bump += 1
	
	var collision = move_and_collide(velocity * delta)
	
	if not collision: return
	if collision.get_collider().is_in_group("Ball"):
		pass
		
func set_bumping(new_value: bool) -> void:
	bumping = new_value
	
func get_bumping() -> bool:
	return bumping
	
func launch_ball() -> void:
	emit_signal("start")
	ball_attached.launch()
	ball_attached = null

func _on_DashTimer_timeout() -> void:
	dashing = false
