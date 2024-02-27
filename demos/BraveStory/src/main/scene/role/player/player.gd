class_name Player
extends CharacterBody2D

@export var can_combo: bool = false
@export var direction: Direction = Direction.RIGHT:
	set(v):
		direction = v
		## 等待节点ready
		if not is_node_ready():
			await ready
		graphics.scale.x = direction

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var hand_checker: RayCast2D = $Graphics/HandChecker
@onready var foot_checker: RayCast2D = $Graphics/FootChecker
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = Game.player_stats
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var slide_request_timer: Timer = $SlideRequestTimer
@onready var interaction_icon: AnimatedSprite2D = $InteractionIcon
@onready var game_over_screen: Control = $CanvasLayer/GameOverScreen

enum Direction {
	LEFT = -1,
	RIGHT = 1,
}

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
	SLIDING_START,
	SLIDING_LOOP,
	SLIDING_END,
}

const GROUND_SATATES := [State.IDLE, State.RUNNING, State.LANDING, State.ATTACK_1, State.ATTACK_2, State.ATTACK_3]
const RUN_SPEED: float = 200.0
const FLOOR_ACCELERATION: float = RUN_SPEED/0.2
const AIR_ACCELERATION: float = RUN_SPEED/0.1
const JUMP_VELOCITY: float = -320.0
const WALL_JUMP_VELOCITY: Vector2 = Vector2(400, -280)
const KNOCKBACK_AMOUNT: float = 512.0
const SLIDING_DURATION: float = 0.2
const SLIDING_SPEED: float = 250.0
const SLIDING_ENERGY: float = 4.0
const LANDING_HEIGHT: float = 100.0

var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float
## 是否是第一帧
var is_first_tick: bool = false
var is_combo_requested: bool = false
var pending_damage: Damage
var fall_from_y: float
var interracting_with: Array[Interactable]

func _ready() -> void:
	## 解决在初始化时角色状态由IDLE转换成FALL的问题
	stand(default_gravity, 0.01)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	if event.is_action_pressed("attack") and can_combo:
		is_combo_requested = true
	
	if event.is_action_pressed("slide"):
		slide_request_timer.start()
	
	if event.is_action_pressed("interact") and not interracting_with.is_empty():
		interracting_with.back().interact()

func tick_physics(delta: float, state: State) -> void:
	interaction_icon.visible = not interracting_with.is_empty()
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
			direction = Direction.LEFT if get_wall_normal().x < 0 else Direction.RIGHT
		State.WALL_JUMP:
			if state_machine.state_time < 0.1:
				stand(0.0 if is_first_tick else default_gravity, delta)
				direction = Direction.LEFT if get_wall_normal().x < 0 else Direction.RIGHT
			else:
				move(delta, 0.0 if is_first_tick else default_gravity)
		State.ATTACK_1, State.ATTACK_2, State.ATTACK_3:
			stand(default_gravity, delta)
		State.HURT, State.DYING:
			stand(default_gravity, delta)
		State.SLIDING_START, State.SLIDING_LOOP:
			slide(delta)
		State.SLIDING_END:
			stand(default_gravity, delta)
	is_first_tick = false

func move(delta: float, gravity: float) -> void:
	var movement := Input.get_axis("move_left", "move_right")
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, movement * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta
	
	if not is_zero_approx(movement):
		direction = Direction.LEFT if movement < 0 else Direction.RIGHT
	
	move_and_slide()


func stand(gravity: float, delta: float) -> void:
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta
	move_and_slide()


func slide(delta: float) -> void:
	velocity.x = graphics.scale.x * SLIDING_SPEED
	velocity.y += default_gravity * delta
	move_and_slide()


func die() -> void:
	game_over_screen.show_game_over()


## 注册交互对象
func register_interactable(v: Interactable) -> void:
	if state_machine.current_state == State.DYING:
		return
	if v in interracting_with:
		return
	interracting_with.append(v)


## 注销交互对象
func unregister_interactable(v: Interactable) -> void:
	interracting_with.erase(v)


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
		var movement := Input.get_axis("move_left", "move_right")
		var is_still := is_zero_approx(movement) and is_zero_approx(velocity.x)
		match state:
			State.IDLE:
				if Input.is_action_just_pressed("attack"):
					next_state = State.ATTACK_1
				elif should_slide():
					next_state = State.SLIDING_START
				elif not is_still:
					next_state = State.RUNNING
			State.RUNNING:
				if Input.is_action_just_pressed("attack"):
						next_state = State.ATTACK_1
				elif should_slide():
					next_state = State.SLIDING_START
				elif is_still:
					next_state = State.IDLE
			State.JUMP:
				if velocity.y >= 0:
					next_state = State.FALL
			State.FALL:
				if is_on_floor():
					var height: float = global_position.y - fall_from_y
					next_state = State.LANDING if height >= LANDING_HEIGHT else State.RUNNING
				elif can_wall_slide():
					next_state = State.WALL_SLIDING
			State.LANDING:
				if not animation_player.is_playing():
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
			State.SLIDING_START:
				if not animation_player.is_playing():
					next_state = State.SLIDING_LOOP
			State.SLIDING_END:
				if not animation_player.is_playing():
					next_state = State.IDLE
			State.SLIDING_LOOP:
				if state_machine.state_time > SLIDING_DURATION or is_on_wall():
					next_state = State.SLIDING_END
	return next_state


func should_slide() -> bool:
	if slide_request_timer.is_stopped() or foot_checker.is_colliding() or stats.energy < SLIDING_ENERGY:
		return false
	
	return true


func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [
		#Engine.get_physics_frames(),
		#State.keys()[from] if from != 1 else "<START>",
		#State.keys()[to],
		#])
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
			fall_from_y = global_position.y
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
			interracting_with.clear()
		State.SLIDING_START:
			animation_player.play("sliding_start")
			slide_request_timer.stop()
			stats.energy -= SLIDING_ENERGY
		State.SLIDING_LOOP:
			animation_player.play("sliding_loop")
		State.SLIDING_END:
			animation_player.play("sliding_end")
		
	is_first_tick = true


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	if invincible_timer.time_left > 0:
		return
	
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
