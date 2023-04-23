extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var blood: Node2D = $Blood


# 大本营初始血量
@export var camp_blood = 1000


# 没有血量时触发游戏结束信号
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blood.blood_max = camp_blood
	blood.init()
	animation_player.play("windmill_rotation")


func dead() -> void:
	emit_signal("game_over")
	get_tree().paused = true


func _on_hitbox_hurt(damage, angle, knockback) -> void:
	damage = damage * (-1)
	camp_blood = clamp(camp_blood + damage, 0, camp_blood)
	blood.value_change(damage)
	if camp_blood <= 0:
		dead()
	else:
		pass
