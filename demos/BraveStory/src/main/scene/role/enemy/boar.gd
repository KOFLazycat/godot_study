extends Enemy

@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var calm_down_timer: Timer = $CalmDownTimer


enum State {
	IDLE,
	WALK,
	RUN,
	HURT,
	DYING,
}
const KNOCKBACK_AMOUNT: float = 512.0

var pending_damage: Damage

func can_see_player() -> bool:
	if not player_checker.is_colliding():
		return false
	return player_checker.get_collider() is Player


func get_next_state(state: State) -> int:
	var next_state := StateMachine.KEEP_CURRENT
	
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DYING else State.DYING
	
	if pending_damage:
		return State.HURT
	
	match state:
		State.IDLE:
			if can_see_player():
				next_state = State.RUN
			elif state_machine.state_time > 2:
				next_state = State.WALK
		State.WALK:
			if can_see_player():
				next_state = State.RUN
			elif wall_checker.is_colliding() or not floor_checker.is_colliding():
				next_state = State.IDLE
		State.RUN:
			if not can_see_player() and calm_down_timer.is_stopped():
				next_state = State.WALK
		State.HURT:
			if not animation_player.is_playing():
				next_state = State.RUN
		
	return next_state


func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" % [
		Engine.get_physics_frames(),
		State.keys()[from] if from != 1 else "<START>",
		State.keys()[to],
		])
	match to:
		State.IDLE:
			animation_player.play("idle")
			if wall_checker.is_colliding():
				direction *= -1
		State.WALK:
			animation_player.play("walk")
			if not floor_checker.is_colliding():
				direction *= -1
				floor_checker.force_raycast_update()
		State.RUN:
			animation_player.play("run")
		State.HURT:
			animation_player.play("hit")
			stats.health -= pending_damage.amount
			var dir: Vector2 = pending_damage.source.global_position.direction_to(global_position)
			velocity = dir * KNOCKBACK_AMOUNT
			
			# 野猪受攻击时朝向玩家
			if dir.x > 0:
				direction = Direction.LEFT
			else:
				direction = Direction.RIGHT
			
			pending_damage = null
			
		State.DYING:
			animation_player.play("die")


func tick_physics(delta: float, state: State) -> void:
	match state:
		State.IDLE, State.HURT, State.DYING:
			move(delta, 0.0)
		State.WALK:
			move(delta, max_speed / 3)
		State.RUN:
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				direction *= -1
			move(delta, max_speed)
			if can_see_player():
				calm_down_timer.start()
		


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
