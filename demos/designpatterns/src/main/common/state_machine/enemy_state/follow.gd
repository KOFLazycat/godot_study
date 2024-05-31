extends State

@onready var enemy: Enemy = get_tree().get_first_node_in_group("enemy")


## 状态进入
func enter() -> void: 
	print("Enemy Follow.")
	enemy.speed = enemy.max_speed
	pass

## 帧更新
func update(_delta: float) -> void: 
	if enemy.global_position.distance_to(enemy.target.position) > enemy.follow_distance:
		update_state.emit("ROAM")
	elif enemy.global_position.distance_to(enemy.target.position) < enemy.attack_distance:
		update_state.emit("ATTACK")
	enemy.dir = enemy.global_position.direction_to(enemy.target.global_position)
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: 
	enemy.velocity = enemy.dir * enemy.speed
	pass 

## 状态退出
func exit() -> void: 
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.speed)
	pass
