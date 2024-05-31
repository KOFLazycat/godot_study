extends State

@onready var enemy: Enemy = get_tree().get_first_node_in_group("enemy")


## 状态进入
func enter() -> void: 
	print("Enemy Idle.")
	enemy.idel_and_roam_time = randf_range(enemy.min_idel_and_roam_time, enemy.max_idel_and_roam_time)
	pass

## 帧更新
func update(_delta: float) -> void: 
	if enemy.global_position.distance_to(enemy.target.position) <= enemy.follow_distance:
		update_state.emit("FOLLOW")
	else:
		enemy.idel_and_roam_time -= _delta
		if is_zero_approx(enemy.idel_and_roam_time):
			update_state.emit("ROAM")
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: pass 

## 状态退出
func exit() -> void: pass
