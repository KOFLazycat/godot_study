extends CharacterBody2D


var movement_speed = 40.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP

#经验
var experience = 0
var experience_level = 1
var collected_exprience = 0

#Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")
#AttackNodes
@onready var ice_spear_timer = %IceSpearTimer
@onready var ice_spear_attack_timer = %IceSpearAttackTimer
@onready var tornado_timer = %TornadoTimer
@onready var tornado_attack_timer = %TornadoAttackTimer
@onready var javelin_base = $Attack/JavelinBase

#UPGRADES
var collected_upgrades = []
var upgrade_options_array = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0
#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0
#Javelin
var javelin_ammo = 0
var javelin_level = 0
#Enemy Related
var enemy_close = []


@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

#GUI
@onready var experience_bar = %ExperienceBar
@onready var lbl_level = %LblLevel
@onready var level_up = %LevelUp
@onready var upgrade_options = %UpgradeOptions
@onready var snd_level_up = %SndLevelUp
@onready var item_option = preload("res://Utility/item_option.tscn")


func _ready():
	upgrade_character("icespear1")
	attack()
	set_expbar(experience, calculate_expriencecap())


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
		last_movement = mov
		animation_player.play("player_walk")
	
	velocity = mov.normalized() * movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage, _angle, _knockback_amount):
	hp -= clamp(damage - armor, 1.0, 999.0)


func attack():
	if icespear_level > 0:
		ice_spear_timer.wait_time = icespear_attackspeed * (1 - spell_cooldown)
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
	if tornado_level > 0:
		tornado_timer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornado_timer.is_stopped():
			tornado_timer.start()
	if javelin_level > 0:
		spawn_javelin()


func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo + additional_attacks
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


func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo + additional_attacks
	tornado_attack_timer.start()


func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornado_attack_timer.start()
		else:
			tornado_attack_timer.stop()
	else:
		tornado_attack_timer.stop()


func spawn_javelin():
	var get_javelin_total = javelin_base.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelin_base.add_child(javelin_spawn)
		calc_spawns -= 1
	#Update Javelin
	var get_javelins = javelin_base.get_children()
	for i in get_javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()


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


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_exprience(gem_exp)


func calculate_exprience(gem_exp):
	var exp_required = calculate_expriencecap()
	collected_exprience += gem_exp
	if experience + collected_exprience > exp_required:#level up
		collected_exprience -= exp_required - experience
		experience_level += 1
		experience = 0
		exp_required = calculate_expriencecap()
		levelup()
	else:
		experience += collected_exprience
		collected_exprience = 0
	set_expbar(experience, exp_required)
	
	
func calculate_expriencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap += experience_level * 5
	elif experience_level < 40:
		exp_cap += 95 + (experience_level - 19) * 8
	else:
		exp_cap += 255 + (experience_level - 39) * 12
	return exp_cap


func set_expbar(set_value = 1, set_max_value = 100):
	experience_bar.value = set_value
	experience_bar.max_value = set_max_value


# 升级
func levelup():
	snd_level_up.play()
	lbl_level.text = ("Level: " + str(experience_level))
	var tween = create_tween()
	tween.tween_property(level_up, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	level_up.visible = true
	var options = 0
	var options_max = 3
	while options < options_max:
		var option_choice = item_option.instantiate()
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options += 1
	await tween.finished
	get_tree().paused = true


func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
	
	attack()
	# 先取消暂停
	get_tree().paused = false
	var tween = create_tween()
	tween.tween_property(level_up, "position", Vector2(-350, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	await tween.finished
	var option_children = upgrade_options.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options_array.clear()
	collected_upgrades.append(upgrade)
	level_up.visible = false
	level_up.position = Vector2(800, 50)
	calculate_exprience(0)


func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrade
			pass
		elif i in upgrade_options_array:#If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":#Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:#Check for PreRequisite
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:#
					pass
				else:
					dblist.append(i)
					continue
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options_array.append(randomitem)
		return randomitem
	else:
		return null
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
