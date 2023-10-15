extends Enemy

@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var calm_down_timer: Timer = $CalmDownTimer


enum State {
	IDLE,
	WALK,
	RUN,
}


func can_see_player() -> bool:
	if not player_checker.is_colliding():
		return false
	return player_checker.get_collider() is Player


func get_next_state(state: State) -> State:
	var next_state := state
	if can_see_player():
		next_state = State.RUN
	else:
		match state:
			State.IDLE:
				if state_machine.state_time > 2:
					next_state = State.WALK
			State.WALK:
				if wall_checker.is_colliding() or not floor_checker.is_colliding():
					next_state = State.IDLE
			State.RUN:
				if calm_down_timer.is_stopped():
					next_state = State.WALK

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


func tick_physics(delta: float, state: State) -> void:
	match state:
		State.IDLE:
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
	print("Ouch!")
