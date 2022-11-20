extends CharacterBody2D


var movement_speed = 40.0
var hp = 80

#Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
#AttackNodes
@onready var ice_spear_timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer = $Attack/IceSpearTimer/IceSpearAttackTimer
#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 10
var icespear_attackspeed = 1.5
var icespear_level = 1
#Enemy Related
var enemy_close = []


@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer


func _ready():
	attack()


func _physics_process(delta):
	movement()
	
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	if mov.x > 0:
		sprite_2d.flip_h = true
	if mov.x < 0:
		sprite_2d.flip_h = false
	
	if mov == Vector2.ZERO:
		animation_player.stop()
	else:
		animation_player.play("player_walk")
	
	velocity = mov.normalized() * movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage


func attack():
	if icespear_level > 0:
		ice_spear_timer.wait_time = icespear_attackspeed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()


func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo
	ice_spear_attack_timer.start()


func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()
	else:
		ice_spear_attack_timer.stop()


func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP



func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
