extends CharacterBody2D


@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var ice_spear_timer: Timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer: Timer = $Attack/IceSpearTimer/IceSpearAttackTimer
@onready var tornado_timer: Timer = $Attack/TornadoTimer
@onready var tornado_attack_timer: Timer = $Attack/TornadoTimer/TornadoAttackTimer
@onready var javelin_base: Node2D = $Attack/JavelinBase
@onready var experience_bar: TextureProgressBar = $GUILayer/GUI/ExperienceBar
@onready var label_level: Label = $GUILayer/GUI/ExperienceBar/LabelLevel
@onready var level_up: Panel = $GUILayer/GUI/LevelUp
@onready var label_level_up: Label = $GUILayer/GUI/LevelUp/LabelLevelUp
@onready var upgrade_options_vbox: VBoxContainer = $GUILayer/GUI/LevelUp/UpgradeOptions
@onready var snd_level_up: AudioStreamPlayer = $GUILayer/GUI/LevelUp/SndLevelUp
@onready var health_bar: TextureProgressBar = $GUILayer/GUI/HealthBar
@onready var label_time: Label = $GUILayer/GUI/LabelTime
@onready var collected_weapon: GridContainer = $GUILayer/GUI/CollectedWeapon
@onready var collected_upgrade: GridContainer = $GUILayer/GUI/CollectedUpgrade
@onready var death_panel: Panel = $GUILayer/GUI/DeathPanel
@onready var btn_menu: Button = $GUILayer/GUI/DeathPanel/BtnMenu
@onready var label_result: Label = %LabelResult
@onready var snd_victory: AudioStreamPlayer = %SndVictory
@onready var snd_lose: AudioStreamPlayer = %SndLose
@onready var item_option_tscn = preload("res://src/main/scene/role/item/item_option.tscn")
@onready var item_container_tscn = preload("res://src/main/scene/ui/item/item_container.tscn")


@export var movement_speed: float = 100.0
@export var hp: float = 50.0
var maxhp: float = 50.0
var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0
var time: int = 0

#Attacks
var ice_spear_tscn = preload("res://src/main/scene/role/bullet/ice_spear/ice_spear.tscn")
var tornado_tscn = preload("res://src/main/scene/role/bullet/tornado/tornado.tscn")
var javelin_tscn = preload("res://src/main/scene/role/bullet/javelin/javelin.tscn")

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
var ice_spear_baseammo: int = 0
var ice_spear_attackspeed: float = 1.5
var ice_spear_level: int = 0

#Tornado
var tornado_ammo: int = 0
var tornado_baseammo: int = 0
var tornado_attackspeed: float = 3.0
var tornado_level: int = 0

#Javelins
var javelin_ammo = 0
var javelin_level = 0


#Enemy Related
var enemy_close = []

var last_movement: Vector2 = Vector2.UP

signal player_death()

func _ready() -> void:
	attack()
	set_expbar(experience, calculate_experiencecap())
	upgrade_character("icespear1")
	health_bar.max_value = maxhp
	health_bar.value = hp


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
		last_movement = mov
		animation_player.play("walk1")
		
	velocity = mov.normalized()*(movement_speed + movement_speed_offset)
	move_and_slide()


func attack() -> void:
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attackspeed * (1 - spell_cooldown)
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
	if tornado_level > 0:
		tornado_timer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornado_timer.is_stopped():
			tornado_timer.start()
	if javelin_level > 0:
		spawn_javelin()


func _on_hurt_box_hurt(damage, _knockback_amount: float, _angle: Vector2) -> void:
	hp -= clamp(damage - armor, 1.0, 999.0)
	health_bar.value = hp
	if hp <= 0:
		death()


func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_baseammo + additional_attacks
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

func spawn_javelin():
	var javelins = javelin_base.get_children()
	var calc_spawns = (javelin_ammo + additional_attacks) - javelins.size()
	while calc_spawns > 0:
		var javelin = javelin_tscn.instantiate()
		javelin.global_position = global_position
		javelin_base.add_child(javelin)
		calc_spawns -= 1
	
	#Update Javelin as well
	for i in javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()


func _on_detection_box_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_detection_box_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_baseammo  + additional_attacks
	tornado_attack_timer.start()


func _on_tornado_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var tornado = tornado_tscn.instantiate()
		tornado.position = position
		tornado.last_movement = last_movement
		tornado.level = tornado_level
		add_child(tornado)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornado_attack_timer.start()
		else:
			tornado_attack_timer.stop()


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.grab()
		calculate_experience(gem_exp)


func calculate_experience(gem_exp: int) -> void:
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		experience_level += 1
		collected_experience -= exp_required-experience
		experience = 0
		exp_required = calculate_experiencecap()
		calculate_experience(0)
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)


func calculate_experiencecap() -> int:
	var exp_cap = 0
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 + (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
	return exp_cap

func set_expbar(set_value: int = 1, set_max_value: int = 100):
	experience_bar.value = set_value
	experience_bar.max_value = set_max_value


func levelup() -> void:
	snd_level_up.play()
	label_level.text = str("Level: ", experience_level)
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var item_option = item_option_tscn.instantiate()
		item_option.item = get_random_item()
		upgrade_options_vbox.add_child(item_option)
		options += 1
		
	var tween = level_up.create_tween()
	tween.tween_property(level_up, "position", Vector2(850, 270), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	level_up.visible = true
	get_tree().paused = true


func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			ice_spear_level = 1
			ice_spear_baseammo += 1
		"icespear2":
			ice_spear_level = 2
			ice_spear_baseammo += 1
		"icespear3":
			ice_spear_level = 3
		"icespear4":
			ice_spear_level = 4
			ice_spear_baseammo += 2
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
			hp = clamp(hp, 0, maxhp)
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgrade_options_vbox.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	level_up.visible = false
	level_up.position = Vector2(850, -470)
	get_tree().paused = false
	calculate_experience(0)


func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
			var is_able_add: bool = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					is_able_add = false
					break
			if is_able_add == true:
				dblist.append(i)
		else: #If there are no prequisites
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist[randi_range(0,dblist.size()-1)]
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null


func change_time(arg_time: int) -> void:
	time = arg_time
	var time_m: int = int(time/60)
	var time_s: int = int(time%60)
	var time_m_str: String = str(time_m)
	var time_s_str: String = str(time_s)
	if time_m < 10:
		time_m_str = str("0", time_m)
	if time_s < 10:
		time_s_str = str("0", time_s)
	label_time.text = str(time_m_str, ":", time_s_str)


func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var item_container = item_container_tscn.instantiate()
			item_container.upgrade = upgrade
			match get_type:
				"weapon":
					collected_weapon.add_child(item_container)
				"upgrade":
					collected_upgrade.add_child(item_container)

#@onready var death_panel: Panel = $GUILayer/GUI/Deathpanel
#@onready var label_result: Label = $GUILayer/GUI/Deathpanel/LabelResult
#@onready var snd_victory: AudioStreamPlayer = $GUILayer/GUI/Deathpanel/SndVictory
#@onready var snd_lose: AudioStreamPlayer = $GUILayer/GUI/Deathpanel/SndLose
#@onready var btn_menu: Button = $GUILayer/GUI/Deathpanel/BtnMenu
func death() -> void:
	death_panel.visible = true
	get_tree().paused = true
	emit_signal("player_death")
	var tween = death_panel.create_tween()
	tween.tween_property(death_panel, "position", Vector2(850, 270), 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	if time >= 300:
		snd_victory.play()
	else:
		snd_lose.play()


func _on_btn_menu_click_end() -> void:
	get_tree().paused = true
	get_tree().change_scene_to_file("res://src/main/scene/ui/menu/menu.tscn")
