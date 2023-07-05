extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_life: Timer = $TimerLife
@onready var hurtbox = $Hurtbox

@export var damage: int = 10

enum MoveTrackType {
	DEFAULT,# 默认轨迹
	BEZIER,# 贝塞尔轨迹
	BEZIER_PARABOLA,# 贝塞尔抛物线轨迹
}

var move_type: int = MoveTrackType.BEZIER
# 子弹可以穿越敌人的次数
var bullet_damage_num: int = 1
var speed: int = 300
var steer_force: int = 10
var acc: Vector2 = Vector2.ZERO
var target: Area2D = null
var rotation_offset: float = 0.11
var bullet_life: int = 5
# 子弹当前行进时间
var cur_time: float = 0.0
var next_point = Vector2.ZERO
var cur_tower_pos = Vector2.ZERO
var cur_enemy_pos = Vector2.ZERO
var length_base = 2.236# 抛物线控制点斜边长度base

func _ready() -> void:
	hurtbox.damage = damage
	hurtbox.damage_num = bullet_damage_num
	timer_life.start(bullet_life)
	cur_tower_pos = position
	if is_instance_valid(target):
		cur_enemy_pos = target.global_position


func _physics_process(delta: float) -> void:
	animated_sprite_2d.rotation += rotation_offset
	if is_instance_valid(target):
		match move_type:
			MoveTrackType.DEFAULT:
				move_default(delta)
			MoveTrackType.BEZIER:
				move_bezier(delta)
			MoveTrackType.BEZIER_PARABOLA:
				move_bezier_parabola(delta)
			_:
				move_default(delta)
	else:
		dead()


func _on_timer_life_timeout() -> void:
	dead()


func fire(_pos: Vector2, _tar: Area2D) -> void:
	position = _pos
	target = _tar


func dead() -> void:
	speed = 0
	velocity = Vector2.ZERO
	timer_life.stop()
	queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		bullet_damage_num -= 1
		if bullet_damage_num == 0:
			dead()


func move_default(delta: float) -> void:
	var desired_v = global_position.direction_to(target.global_position)*speed
	var steer = (desired_v - velocity).normalized()*steer_force
	acc += steer
	velocity += acc * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	position += velocity*delta


func move_bezier(delta: float) -> void:
	cur_time += delta	
	var distance = global_position.distance_to(target.global_position)
	var all_time = distance / speed
	var t = min(cur_time / all_time, 1)
	var start_control_point = global_position + Vector2(0, randi_range(50, 100))*(-1)
	next_point = global_position.bezier_interpolate(start_control_point, target.global_position, target.global_position, t)
	look_at(next_point)
	global_position = global_position.move_toward(next_point, speed * delta)


func move_bezier_parabola(delta: float) -> void:
	cur_time += delta
	var distance = cur_tower_pos.distance_to(cur_enemy_pos)
	var all_time = distance / speed
	var t = min(cur_time / all_time, 1)
	var control_p_v = cur_tower_pos.direction_to(cur_enemy_pos)*distance*length_base/3
	var rrr = acos(1/length_base)
	if control_p_v.x > 0:
		rrr = rrr * (-1)
	control_p_v = control_p_v.rotated(rrr)
	var start_control_point = cur_tower_pos + control_p_v
	next_point = cur_tower_pos.bezier_interpolate(start_control_point, start_control_point, cur_enemy_pos, t)
	look_at(next_point)
	global_position = global_position.move_toward(next_point, speed * delta)
