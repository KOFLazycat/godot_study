extends Node

enum Difficulty {
	NORMAL,
	HARD
}
@export var difficulty = Difficulty.NORMAL


var total_coin: int = 0
var _is_game_over: bool = false

func reset_game_state():
	_is_game_over = false
	total_coin = 0


func get_total_coin():
	return total_coin


func is_game_over() -> bool:
	return _is_game_over
	
# 增加coin
func add_coin(coin_value: int):
	total_coin += coin_value


# 减少coin
func sub_coin(coin_value: int):
	total_coin -= coin_value
	if total_coin < 0:
		total_coin = 0


func set_game_over():
	_is_game_over = true
	$TimerGameOver.start()


func _on_timer_game_over_timeout() -> void:
	get_tree().paused = true
	get_tree().root.add_child(preload("res://src/main/scene/main.tscn").instantiate() )
