extends Area2D

@onready var snd_coin: AudioStreamPlayer2D = $SndCoin
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var ui_coin = get_tree().get_first_node_in_group("ui_coin") as Area2D

var coin_value: int = 10
var ui_coin_pos: Vector2 = Vector2.ZERO
var start_pos: Vector2 = Vector2.ZERO
var control_pos: Vector2 = Vector2.ZERO
# 控制点偏移因子
var control_pos_offset_factor: float = 0.3
# 飞行总时间
var fly_time: float = 1
# 当前已飞行时间
var cur_fly_time: float = 0.0
var time_fly_delay: float = 0.5
var is_able_fly: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = global_position
	ui_coin_pos= ui_coin.global_position
	timer.start(time_fly_delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 开始移动
	if is_able_fly:
		cur_fly_time += delta
		if cur_fly_time < fly_time:
			global_position = get_next_pos()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ui_coin"):
		print(self)
		Global.add_coin(coin_value)
#		print(Global.get_total_coin())
		set_deferred("visible", false)
#		collision_shape_2d.call_deferred("set", "disabled", true)
		snd_coin.play()


func _on_snd_coin_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	is_able_fly = true


func get_control_pos() -> void:
	# 中间点
	var cent_pos = (ui_coin_pos - start_pos) / 2 + start_pos
	control_pos = (ui_coin_pos - start_pos).rotated(PI/2)*control_pos_offset_factor + cent_pos


func get_next_pos() -> Vector2:
	return start_pos.bezier_interpolate(control_pos, ui_coin_pos, ui_coin_pos, cur_fly_time / fly_time)
