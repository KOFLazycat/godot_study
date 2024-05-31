extends State

@onready var player: Player = get_tree().get_first_node_in_group("player")


## 状态进入
func enter() -> void: 
	print("Player Sprint.")
	player.sprint_time = player.max_sprint_time
	pass

## 帧更新
func update(_delta: float) -> void: 
	player.sprint_time -= _delta
	if player.sprint_time == 0:
		update_state.emit("IDLE")
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: 
	player.velocity = player.dir * player.speed * 3.0
	pass 

## 状态退出
func exit() -> void: pass
