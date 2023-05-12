extends CharacterBody2D


@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var ice_spear_timer: Timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer: Timer = $Attack/IceSpearTimer/IceSpearAttackTimer

@export var movement_speed: float = 400.0
@export var hp: float = 80.0

#Attacks
var ice_spear_tscn = preload("res://src/main/scene/role/bullet/ice_spear/ice_spear.tscn")

#Upgrades
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#IceSpear
var ice_spear_ammo: int = 0
var ice_spear_baseammo: int = 1
var ice_spear_attackspeed: float = 1.5
var ice_spear_level: int = 1


#Enemy Related
var enemy_close = []


func _ready() -> void:
	attack()


func _physics_process(delta):
	movement()
	

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x < 0:
		sprite_2d.flip_h = true
	if mov.x > 0:
		sprite_2d.flip_h = false
	
	var movement_speed_offset = 0
	if mov == Vector2.ZERO:
		animation_player.play("idle1")
	else:
		animation_player.play("walk1")
		
	velocity = mov.normalized()*(movement_speed + movement_speed_offset)
	move_and_slide()


func attack() -> void:
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attackspeed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()


func _on_hurt_box_hurt(damage, _knockback_amount: float, _angle: Vector2) -> void:
	hp -= damage
	print(hp)


func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_baseammo
	ice_spear_attack_timer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear = ice_spear_tscn.instantiate()
		ice_spear.position = position
		ice_spear.target = get_random_target()
		ice_spear.level = ice_spear_level
		add_child(ice_spear)
		ice_spear_ammo -= 1
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()
	

func get_random_target() -> Vector2:
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
	
	return Vector2.ZERO


func _on_detection_box_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_detection_box_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
