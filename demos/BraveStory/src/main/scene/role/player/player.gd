class_name Player
extends CharacterBody2D

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var hand_checker: RayCast2D = $Graphics/HandChecker
@onready var foot_checker: RayCast2D = $Graphics/FootChecker
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = $Stats
@onready var invincible_timer: Timer = $InvincibleTimer


enum State {
	IDLE,
	RUNNING,
	JUMP,
	FALL,
	LANDING,
	WALL_SLIDING,
	WALL_JUMP,
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	HURT,
	DYING,
}

const GROUND_SATATES := [State.IDLE, State.RUNNING, State.LANDING, State.ATTACK_1, State.ATTACK_2, State.ATTACK_3]
const RUN_SPEED: float = 200.0
const FLOOR_ACCELERATION: float = RUN_SPEED/0.2
const AIR_ACCELERATION: float = RUN_SPEED/0.1
const JUMP_VELOCITY: float = -320.0
const WALL_JUMP_VELOCITY: Vector2 = Vector2(400, -280)
const KNOCKBACK_AMOUNT: float = 512.0
@export var can_combo: bool = false
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float
## 是否是第一帧
var is_first_tick: bool = false
var is_combo_requested: bool = false
var pending_damage: Damage

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	if event.is_action_pressed("attack") and can_combo:
		is_combo_requested = true


func tick_physics(delta: float, state: State) -> void:
	if invincible_timer.time_left > 0:
		graphics.modulate.a = sin(Time.get_ticks_msec()/30) * 0.5 + 0.5
	else:
		graphics.modulate.a = 1
	
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
			stand(default_gravity, delta)
		State.WALL_SLIDING:
			move(delta, default_gravity / 20)
			graphics.scale.x = get_wall_normal().x
		State.WALL_JUMP:
			if state_machine.state_time < 0.1:
				stand(0.0 if is_first_tick else default_gravity, delta)
				graphics.scale.x = get_wall_normal().x
			else:
				move(delta, 0.0 if is_first_tick else default_gravity)
		State.ATTACK_1, State.ATTACK_2, State.ATTACK_3:
			stand(default_gravity, delta)
		State.HURT, State.DYING:
			stand(default_gravity, delta)
	is_first_tick = false

func move(delta: float, gravity: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta
	
	if not is_zero_approx(direction):
		graphics.scale.x = -1 if direction < 0 else +1
	
	move_and_slide()


func stand(gravity: float, delta: float) -> void:
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta
	move_and_slide()


func die() -> void:
	get_tree().reload_current_scene()


func can_wall_slide() -> bool:
	return is_on_wall() and hand_checker.is_colliding() and foot_checker.is_colliding()


func get_next_state(state: State) -> int:
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DYING else State.DYING
	
	if pending_damage:
		return State.HURT
	
	var next_state := StateMachine.KEEP_CURRENT
	var can_jump: bool = is_on_floor() or coyote_timer.time_left > 0
	var should_jump: bool = can_jump and jump_request_timer.time_left > 0
	if should_jump:
		next_state = State.JUMP
	elif state in GROUND_SATATES and not is_on_floor():
		next_state = State.FALL
	else:
		var direction := Input.get_axis("move_left", "move_right")
		var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
		match state:
			State.IDLE:
				if Input.is_action_just_pressed("attack"):
					next_state = State.ATTACK_1
				elif not is_still:
					next_state = State.RUNNING
			State.RUNNING:
				if Input.is_action_just_pressed("attack"):
						next_state = State.ATTACK_1
				elif is_still:
					next_state = State.IDLE
			State.JUMP:
				if velocity.y >= 0:
					next_state = State.FALL
			State.FALL:
				if is_on_floor():
					next_state = State.LANDING if is_still else State.RUNNING
				elif can_wall_slide():
					next_state = State.WALL_SLIDING
			State.LANDING:
				if not is_still:
					next_state = State.RUNNING
				elif not animation_player.is_playing():
					next_state = State.IDLE
			State.WALL_SLIDING:
				if jump_request_timer.time_left > 0:
					next_state = State.WALL_JUMP
				else:
					if is_on_floor():
						next_state = State.IDLE
					elif not is_on_wall():
						next_state = State.FALL
			State.WALL_JUMP:
				if can_wall_slide() and not is_first_tick:
					next_state = State.WALL_SLIDING
				elif velocity.y >= 0:
					next_state = State.FALL
			State.ATTACK_1:
				if not animation_player.is_playing():
					next_state = State.ATTACK_2 if is_combo_requested else State.IDLE
			State.ATTACK_2:
				if not animation_player.is_playing():
					next_state = State.ATTACK_3 if is_combo_requested else State.IDLE
			State.ATTACK_3:
				if not animation_player.is_playing():
					next_state = State.IDLE
			State.HURT:
				if not animation_player.is_playing():
					next_state = State.IDLE
	return next_state


func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" % [
		Engine.get_physics_frames(),
		State.keys()[from] if from != 1 else "<START>",
		State.keys()[to],
		])
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
		State.WALL_JUMP:
			animation_player.play("jump")
			velocity = WALL_JUMP_VELOCITY
			velocity.x *= get_wall_normal().x
			jump_request_timer.stop()
		State.ATTACK_1:
			animation_player.play("attack_1")
			is_combo_requested = false
		State.ATTACK_2:
			animation_player.play("attack_2")
			is_combo_requested = false
		State.ATTACK_3:
			animation_player.play("attack_3")
			is_combo_requested = false
		State.HURT:
			animation_player.play("hurt")
			stats.health -= pending_damage.amount
			var dir: Vector2 = pending_damage.source.global_position.direction_to(global_position)
			velocity = dir * KNOCKBACK_AMOUNT
			invincible_timer.start()
			pending_damage = null
		State.DYING:
			animation_player.play("die")
			invincible_timer.stop()
		
	is_first_tick = true


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	if invincible_timer.time_left > 0:
		return
	
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
