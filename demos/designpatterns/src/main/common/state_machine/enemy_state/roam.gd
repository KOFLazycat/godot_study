extends State

@onready var enemy: Enemy = get_tree().get_first_node_in_group("enemy")


## 状态进入
func enter() -> void: 
	print("Enemy Roam.")
	enemy.idel_and_roam_time = randf_range(enemy.min_idel_and_roam_time, enemy.max_idel_and_roam_time)
	enemy.speed = randf_range(enemy.min_speed, enemy.max_speed)
	enemy.dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	pass

## 帧更新
func update(_delta: float) -> void: 
	if enemy.global_position.distance_to(enemy.target.position) <= enemy.follow_distance:
		update_state.emit("FOLLOW")
	else:
		enemy.idel_and_roam_time -= _delta
		if is_zero_approx(enemy.idel_and_roam_time):
			update_state.emit("IDLE")
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: 
	enemy.velocity = enemy.dir * enemy.speed
	pass 

## 状态退出
func exit() -> void: 
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.speed)
	pass
