extends State

@onready var player: Player = get_tree().get_first_node_in_group("player")


## 状态进入
func enter() -> void: 
	print("Player move.")
	pass

## 帧更新
func update(_delta: float) -> void: 
	if player.is_sprint:
		update_state.emit("SPRINT")
	elif player.dir == Vector2.ZERO:
		update_state.emit("IDLE")
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: 
	player.velocity = player.dir * player.speed
	pass 

## 状态退出
func exit() -> void: 
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.speed)
	pass
