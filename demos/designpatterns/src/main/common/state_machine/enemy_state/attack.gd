extends State

@onready var enemy: Enemy = get_tree().get_first_node_in_group("enemy")


## 状态进入
func enter() -> void: 
	print("Enemy Attack.")
	enemy.attack_time = enemy.max_attack_time
	pass

## 帧更新
func update(_delta: float) -> void: 
	if enemy.global_position.distance_to(enemy.target.position) >= enemy.exit_attack_distance:
		update_state.emit("FOLLOW")
	else :
		enemy.attack_time -= _delta
		if is_zero_approx(enemy.attack_time):
			enemy.attack_time = enemy.max_attack_time
			print("ATTACK!!!!")
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: pass 

## 状态退出
func exit() -> void: pass
