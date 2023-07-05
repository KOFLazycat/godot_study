extends CharacterBody2D


@onready var mouse: AnimatedSprite2D = $Mouse
@onready var blood: Node2D = $Blood
@onready var animation_player = $AnimationPlayer


# 怪物移动加速度
@export var enemy_speed_acc: float = 0.0
# 怪物最大血量
@export var enemy_blood_max: int = 100
# 怪物死亡掉落金币
@export var enemy_value: int = 5
# 怪物介绍
@export var info: String = "Running Man!!"

var last_pos: Vector2 = Vector2.ZERO
var blood_offset_x: int = -6
var blood_offset_y: int = -16

# 怪物当前血量
var enemy_blood: int = 0
# 怪物等级
var enemy_level: int = 1
# 怪物冲刺目标数组，有的怪物不需要该数组
var target_arr: Array = []
# 怪物当前攻击对象
var current_target = null

signal enemy_die

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_blood = enemy_blood_max
	blood.blood_max = enemy_blood
	blood.init()


func _physics_process(_delta: float) -> void:
	var tmp_v = global_position - last_pos
	if tmp_v != Vector2.ZERO:
		last_pos = global_position
		if abs(tmp_v.x) > abs(tmp_v.y):
			if tmp_v.x > 0:
				mouse.play("walk_right")
				mouse.rotation = 0
			else:
				mouse.play("walk_left")
				mouse.rotation = 0
		else:
			if tmp_v.y > 0:
				mouse.play("walk_down")
				mouse.rotation = -90
			else:
				mouse.play("walk_up")
				mouse.rotation = 90
	
	blood.global_position.x = global_position.x + blood_offset_x
	blood.global_position.y = global_position.y + blood_offset_y
	blood.global_rotation_degrees = 0


func _on_hitbox_hurt(damage, angle, knockback):
	blood.value_change(damage*(-1))
	animation_player.play("take_damage")
	if blood.blood_value <= 0:
		await animation_player.animation_finished
		queue_free()

