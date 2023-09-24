extends CharacterBody2D

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var hand_checker: RayCast2D = $Graphics/HandChecker
@onready var foot_checker: RayCast2D = $Graphics/FootChecker


enum State {
	IDLE,
	RUNNING,
	JUMP,
	FALL,
	LANDING,
	WALL_SLIDING
}

const GROUND_SATATES := [State.IDLE, State.RUNNING, State.LANDING]
const RUN_SPEED: float = 200.0
const FLOOR_ACCELERATION: float = RUN_SPEED/0.2
const AIR_ACCELERATION: float = RUN_SPEED/0.02
const JUMP_VELOCITY: float = -320.0
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float
## 是否是第一帧
var is_first_tick: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2


func tick_physics(delta: float, state: State) -> void:
	match state:
		State.IDLE:
			move(delta, default_gravity)
		State.RUNNING:
			move(delta, default_gravity)
		State.JUMP:
			move(delta, 0.0 if is_first_tick else default_gravity)
		State.FALL:
			move(delta, default_gravity)
		State.LANDING:
			stand(delta)
		State.WALL_SLIDING:
			move(delta, default_gravity / 20)
			graphics.scale.x = get_wall_normal().x
	is_first_tick = false

func move(delta: float, gravity: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta
	
	if not is_zero_approx(direction):
		graphics.scale.x = -1 if direction < 0 else +1
	
	move_and_slide()


func stand(delta: float) -> void:
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += default_gravity * delta
	move_and_slide()


func get_next_state(state: State) -> State:
	var next_state := state
	var can_jump: bool = is_on_floor() or is_on_wall() or coyote_timer.time_left > 0
	var should_jump: bool = can_jump and jump_request_timer.time_left > 0
	if should_jump:
		next_state = State.JUMP
	else:
		var direction := Input.get_axis("move_left", "move_right")
		var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
		match state:
			State.IDLE:
				if not is_on_floor():
					next_state = State.FALL
				else:
					if not is_still:
						next_state = State.RUNNING
			State.RUNNING:
				if is_still:
					next_state = State.IDLE
			State.JUMP:
				if velocity.y >= 0:
					next_state = State.FALL
			State.FALL:
				if is_on_floor():
					next_state = State.LANDING if is_still else State.RUNNING
				elif is_on_wall() and hand_checker.is_colliding() and foot_checker.is_colliding():
					next_state = State.WALL_SLIDING
			State.LANDING:
				if not is_still:
					next_state = State.RUNNING
				elif not animation_player.is_playing():
					next_state = State.IDLE
			State.WALL_SLIDING:
				if is_on_floor():
					next_state = State.IDLE
				elif not is_on_wall():
					next_state = State.FALL
	return next_state


func transition_state(from: State, to: State) -> void:
	if from not in GROUND_SATATES and to in GROUND_SATATES:
		coyote_timer.stop()
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUNNING:
			animation_player.play("running")
		State.JUMP:
			animation_player.play("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
		State.FALL:
			animation_player.play("fall")
			if from in GROUND_SATATES:
				coyote_timer.start()
		State.LANDING:
			animation_player.play("landing")
		State.WALL_SLIDING:
			velocity.y = 0
			animation_player.play("wall_sliding")
	is_first_tick = true
