extends Area2D


var level = 1
var hp = 9999
var speed = 200
var damage = 10
var attack_size = 1.0
var attack_speed = 4.0
var knockback_amount = 100
var paths = 1


var target = Vector2.ZERO
var target_array = []
var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var spr_jav_reg = preload("res://Textures/Items/Weapons/javelin_3_new.png")
var spr_jav_atk = preload("res://Textures/Items/Weapons/javelin_3_new_attack.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var attack_timer = %AttackTimer
@onready var change_direction_timer = %ChangeDirectionTimer
@onready var reset_pos_timer = %ResetPosTimer
@onready var snd_attack = $SndAttack

signal remove_from_array(ogject)


func _ready():
	update_javelin()
	_on_reset_pos_timer_timeout()


func update_javelin():
	level = player.javelin_level
	match level:
		1:
			hp = 9999
			speed = 200
			damage = 10
			attack_size = 1.0
			attack_speed = 4.0
			knockback_amount = 100
			paths = 3
	scale = Vector2(1.0,1.0)*attack_size
	attack_timer.wait_time = attack_speed
	

func _physics_process(delta):
	if target_array.size() > 0:
		position += angle*speed*delta
	else:
		var play_angle = global_position.direction_to(reset_pos)
		var distance_dif = global_position - player.global_position
		# 距离越远速度越快
		var return_speed = 20.0
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_speed = 100.0
		position += play_angle * return_speed * delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)


func add_path():
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
	enable_attack(true)
	target = target_array[0]
	process_path()
	snd_attack.play()
	emit_signal("remove_from_array", self)


func process_path():
	angle = global_position.direction_to(target)
	change_direction_timer.start()
	var tween = create_tween().set_parallel(false)
	var new_rotation_degrees = angle.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", new_rotation_degrees, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
		

func enable_attack(atk = true):
	if atk:
		collision_shape_2d.set_deferred("disabled", false)
		sprite_2d.texture = spr_jav_atk
	else:
		collision_shape_2d.set_deferred("disabled", true)
		sprite_2d.texture = spr_jav_reg


func _on_attack_timer_timeout():
	add_path()


func _on_change_direction_timer_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			snd_attack.play()
			emit_signal("remove_from_array", self)
		else:
			change_direction_timer.stop()
			attack_timer.start()
			enable_attack(false)
	else:
		change_direction_timer.stop()
		attack_timer.start()
		enable_attack(false)


func _on_reset_pos_timer_timeout():
	var choose_direction = randi()%4
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
