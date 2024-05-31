extends State

@onready var player: Player = get_tree().get_first_node_in_group("player")


## 状态进入
func enter() -> void: 
	print("Player Idle.")
	pass

## 帧更新
func update(_delta: float) -> void: 
	if player.is_sprint:
		update_state.emit("SPRINT")
	elif player.dir != Vector2.ZERO:
		update_state.emit("MOVE")
	pass

## 物理帧更新
func physics_update(_delta: float) -> void: pass 

## 状态退出
func exit() -> void: pass
